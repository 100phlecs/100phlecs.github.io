+++
title = 'How I deal with QWERTY'
+++

With a little bit of research you won't be surprised to find the QWERTY layout is inefficient. A knee-jerk reaction would be to learn an alternative layout, which I did to some extent. But then one will inevitably discover all of the other inefficiencies attached to keyboard design. And the exhaustion found in "catching up" toward nowhere.

I bought new keyboards, optimized my layouts further, introduced different "layers" the same way the `Shift` key is a layer for capitals. Though in the name of preventing hand injury, how myopic was the conclusion. Here I was diligently practicing a skill I technically already had, just under new terms, for the marginal gain of typing either quicker or less strenuously. I've since given up (almost) entirely on the ordeal. Here is my Atreus keyboard which is collecting dust.


<figure>
  <img src="/images/atreus.png" alt="atreus keyboard"/>
  <figcaption>I wiped off the dust for this photo. You can see some residual between the keys.</figcaption>
</figure>


One could critique the way in which I approached it all–I completely agree. I fell into the trap anyone does when they begin to question The Defaults: _the endless alternatives and the quest to find the perfect one_. Which is positively overwhelming if you give it enough contemplation. One may find some similarity in the equally nauseating quest of finding the "perfect" stack. 

If you enjoy such quests, then you have much to look forward to with computers and keyboards. But if you're in the no-fun zone like me, or a no-fun zoner in denial (there are many), such quests only serve to frustrate and distract from more interesting stuff. Like actually writing posts or software.

So as a no-fun zoner what have I settled on for my keyboard "experience"? If you are a professional pixel-pusher there's still an underlying incentive to do something about the defaults, unless you enjoy [RSI](https://en.wikipedia.org/wiki/Repetitive_strain_injury). 

Well, I stick with QWERTY and basic QWERTY keyboards, for one. And finally, I use [Karabiner Elements](https://karabiner-elements.pqrs.org/) for some quality of life modifications. More specifically, I use [goku](https://github.com/yqrashawn/GokuRakuJoudo#gokurakujoudo). To this day I do not know how to write native configs for Karabiner, and I hope I never have to.

There are only two essential modifications I use which I would recommend to anyone that uses Emacs keybindings. 

1. Map `Right Command` to `Control`
2. Map `Caps Lock` to `Hyper`[^1]

The first modification makes it easy to use Emacs shortcuts as it's now a thumb press. The second modification allows me to use a layer to access hard-to-reach symbols by mapping them on letter-keys, thereby reducing strain.

Finally, and most importantly, I repurpose both `Caps Lock` and `Right Command` depending on the type of key press. If the keys are held, you have the above mappings.

If they are tapped, however:

1. `Right Command` -> `_`
2. `Caps Lock` -> `Esc`

I often program in [Snake case](https://en.wikipedia.org/wiki/Snake_case) languages. Pressing shift and reaching for `_` gets old and causes strain. Having easy access to underscore with a thumb press feels natural, like pressing the space bar, and has made programming far easier on me.

A caveat to these dual-mappings is accidental mix-ups between the underscore and the control. When I write too quickly, my intended underscore may register as a Control instead, and therefore trigger an Emacs command (i.e. ctrl+a). 

Sometimes there are inefficiencies that you will accept because the alternatives are too complex to bother with and/or setup. This is precisely why I quit using Emacs. As well as NeoVim. I've forever cemented myself as a plebeian to the Config Confederation and may no longer participate in the round table of plugins. 

As a trade off, I only have a few conceptual dotfiles to take along with me. 
Emacs keybindings, some key mappings, and that's it. 
Shouldn't take too much to configure a new computer from scratch.

It's a central question really: _is customization worth the time?_

My answer: _in small doses._

You have my answer, and you are entirely welcome to yours. 


[^1]: `Hyper` is a combination of modifier keys on MacOS. My Hyper is defined as `Option`, `Command`, and `Shift` pressed at the same time. The official `Hyper` definition includes the `Control` key too. I forgot why I removed `Control` from the definition. Vaguely recall that it was due to some conflict with native MacOS keybindings.
