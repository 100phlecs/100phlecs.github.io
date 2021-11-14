(require 'ox-publish)

(setq org-publish-project-alist
      (list
       (list "100phlecs.xyz"
             :recursive t
             :base-directory "./content"
             :publishing-directory "./thoughts"
             :publishing-function 'org-html-publish-to-html
             :with-author nil
             :with-creator t
             :with-toc nil
             :section-numbers nil
             :time-stamp-file nil)))

(setq org-html-validation-link nil
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-container-element "section"
      org-html-head "
<link rel=\"stylesheet\" href=\"../normalize.css\">
<link rel=\"stylesheet\" href=\"../custom.css\">
<link rel=\"stylesheet\" href=\"../iosevka-curly.css\">
"
)

(org-publish-all t)


(message "Build complete")

