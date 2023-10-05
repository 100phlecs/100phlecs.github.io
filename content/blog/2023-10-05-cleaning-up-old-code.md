+++
title = 'Cleaning up old Elixir code'
+++

It's been awhile since I last looked at the `TailwindFormatter` library.

`TailwindFormatter` is a [Mix Format](https://hexdocs.pm/mix/main/Mix.Tasks.Format.html#module-plugins) extension to sort TailwindCSS classes with a few divergences. 

Naively I went for the Regex approach. The algorithm went something like:

1. Fetch all class attributes with a complex Regex
2. Within that, validate and substitute all Elixir code
3. Sort the variants and classes in layers
4. Put back the Elixir functions
5. Add additional ASCII to properly swap it out

Here are the four regex patterns the library uses to find classes:

```elixir
@class_pattern ~r/(?:class\s*(?:=|:)\s*)((\{)|('|"))(.|\s)*?(?(2)\}|("|'))/i
@inline_func_pattern ~r/#\{((?:(?:(?!(#\{|\})).)|(?R))*)\}/i
@dynamic_classes ~r/[[:alnum:]-]*#\{([^}]+)\}*/i
@invalid_input ~r/[^_a-zA-Z0-9\$\s\-:\[\]\/\.\#]+/
```

Pretty complicated...

Reality is that, since the `class` attribute within a Phoenix template can hold any valid Elixir expression, this isn't sustainable. The solution is to use the Phoenix tokenizers and handle the AST representation of each `class`.

So I took the time and converted the library over to use the Phoenix tokenizers. It's a lot simpler, but I wouldn't entirely attribute it to the different approach. After programming in Elixir for awhile, I found some of my previous code easier to clean up.

Here's the new entry point of the plugin:

```elixir
  def format(contents, _opts) do
    contents
    |> HEExTokenizer.tokenize()
    |> Enum.reduce([], &collect_classes/2)
    |> Enum.reduce(contents, &sort_classes/2)
  end
```

`collect_classes` is pretty straightforward:

```elixir
  defp collect_classes({:tag, _name, attrs, _meta}, acc) do
    case Enum.find(attrs, &(elem(&1, 0) == "class")) do
      {"class", class, _meta} -> [class | acc]
      nil -> acc
    end
  end
  ```

`sort_classes` goes more into the AST stuff which I won't go through. What it does is that it handles things like `grid-cols-#{@num}` or `#{if @active, do: "bg-red-50", else: "hidden"}` and `"h-6 " <> if @active, do: "font-bold"`. Elixir expressions.

Instead, let's go to the part where it sorts the `class` string, something like `h-8 w-8 bg-slate-500 md:w-16 md:h-12 lg:flex`.

Here's the previous `sort` function entry point:

```elixir
defp sort([]) do
  []
end

defp sort(class_list) do
  {variants, base_classes} = separate(class_list)
  base_sorted = sort_base_classes(base_classes)
  variant_sorted = sort_variant_classes(variants)

  base_sorted ++ variant_sorted
end
```

For those unfamiliar with Elixir, the above is pattern matching on the function parameter. It goes in declaration order. So in this case, if the parameter passed matches `[]` it goes to the first function, returning a `[]`. Otherwise it continues to check against the other functions.

Let's look at `sort_base_classes(base_classes)`

```elixir
defp sort_base_classes(base_classes) do
  base_classes
  |> Enum.map(fn class ->
    sort_number = get_sort_position(class)
    {sort_number, class}
  end)
  |> Enum.sort_by(&elem(&1, 0))
  |> Enum.map(&elem(&1, 1))
end
```

This was poorly written, and was written by me. You can reduce this down to:

```elixir
Enum.sort_by(base_classes, &class_position/1)
```

I'm not sure why I thought I had to explicitly store the position of the class in order to sort it. But it isn't needed at all.

Another example is `sort_variant_classes`. It's a large chain of functions, bear with me:

```elixir
defp sort_variant_classes(variants) do
  variants
  |> group_by_first_variant()
  |> sort_variant_groups()
  |> sort_classes_per_variant()
  |> grouped_variants_to_list()
end

defp group_by_first_variant(variants) do
  variants
  |> Enum.map(&String.split(&1, ":", parts: 2))
  |> Enum.group_by(&List.first/1, &List.last/1)
end

defp sort_variant_groups(variant_groups) do
  variant_groups
  |> Enum.map(fn variant_group ->
    variant = elem(variant_group, 0)
    sort_number = Map.get(Defaults.variant_order(), variant, -1)

    {sort_number, variant_group}
  end)
  |> Enum.sort_by(&elem(&1, 0))
  |> Enum.map(&elem(&1, 1))
end

defp sort_classes_per_variant(grouped_variants) do
  Enum.map(grouped_variants, fn variant_group ->
    {variant, classes_and_variants} = variant_group
    {variant, sort(classes_and_variants)}
  end)
end

defp grouped_variants_to_list(grouped_variants) do
  Enum.flat_map(grouped_variants, fn variant_group ->
    {variant, base_classes} = variant_group

    Enum.map(base_classes, fn class ->
      "#{variant}:#{class}"
    end)
  end)
end
```

Looking at the previous example of `sort_base_classes()` you may notice the same poorly written pattern in `sort_variant_groups()`. Let's scrap that function entirely:

```elixir
defp sort_variant_classes(variants) do
  variants
  |> group_by_first_variant()
  |> Enum.sort_by(fn {variant, _rest} -> variant_position(variant) end)
  |> sort_classes_per_variant()
  |> grouped_variants_to_list()
end
```

Much simpler and a whole lot more explicit too. I think you only want to use `elem()` when you're dealing with larger tuples. It's better to pattern match against the tuple, and reads a lot easier.

Next on the list is `sort_classes_per_variant()`:

```elixir
defp sort_classes_per_variant(grouped_variants) do
  Enum.map(grouped_variants, fn variant_group ->
    {variant, classes_and_variants} = variant_group
    {variant, sort(classes_and_variants)}
  end)
end
```

This function is pointlessly verbose. Maybe I didn't know about pattern matching in the anonymous function call yet? Not sure.

Let's delete that one too:

```elixir
defp sort_variant_classes(variants) do
  variants
  |> group_by_first_variant()
  |> Enum.sort_by(fn {variant, _rest} -> variant_position(variant) end)
  |> Enum.map(fn {variant, rest} -> {variant, sort(rest)} end)
  |> grouped_variants_to_list()
end
```

And finally, `grouped_variants_to_list()`. Let's look at it once more:

```elixir
defp grouped_variants_to_list(grouped_variants) do
  Enum.flat_map(grouped_variants, fn variant_group ->
    {variant, base_classes} = variant_group

    Enum.map(base_classes, fn class ->
      "#{variant}:#{class}"
    end)
  end)
end
```

This one is okay. It's verbose and unnecessarily pattern matches within the function call, but it isn't too horrible compared to the others. We can use the same logic, just reduce it down a bit more.

Here's the final implementation of `sort_variant_classes()`:

```elixir
defp sort_variant_classes(variants) do
  variants
  |> group_by_first_variant()
  |> Enum.sort_by(fn {variant, _rest} -> variant_position(variant) end)
  |> Enum.map(fn {variant, rest} -> {variant, sort(rest)} end)
  |> Enum.flat_map(fn {variant, rest} -> Enum.map(rest, &"#{variant}:#{&1}") end)
end
```

We deleted roughly ~25 lines of code by taking advantage of function pattern matching.

Here's how the regular sort function looks now:

```elixir
defp sort(class_list) when is_list(class_list) do
  {variants, base_classes} = Enum.split_with(class_list, &variant?/1)

  Enum.sort_by(base_classes, &class_position/1) ++ sort_variant_classes(variants)
end
```

Some may argue that the temporary variable names added clarity, and I'm not entirely sure. 
I like the less noise in this version, but maybe as I program more I will find myself thinking otherwise.

In conclusion, the old approach was messy regex and substitutions. The new version _still_ has substitutions, but this time it's on the AST. The new algorithm:

1. Parse the tree using Phoenix tokenizer
2. Grab all class attributes
3. For class attributes that are strings, pass to `sort()`
4. For class attributes that are expressions, transform to AST and handle each expression type.
5. Render the new sorted string, and substitute it back into the contents.

Expression types can be concatenations (`<>`) or interpolations (`#{@active}`). Arrays too (which I've yet to add support for, but it's coming up now that there's an AST to work with).

Some of the expression `class` code is a little complicated. 
I imagine in time there can be another blog post like this that points out inefficiencies.

Besides support for arrays, I also want to support the `tailwind.config.js` file of the project. Not sure yet how to execute the JS code that extracts the classes from it. Will see.

Feel free to check out [the repository](https://github.com/100phlecs/tailwind_formatter).

Maintenance work can sometimes be grueling, but also satisfying too.

