(defpackage 100phlecs
  (:use :cl))
(in-package :100phlecs)

(defun component-test ()
  (spinneret:with-html
    (:p (:span "hello"))
    (:p (:span "hello"))))
(component-test)

(defun phl-index ()
  (spinneret:with-html-string
    (:doctype)
    (:html
     (:head
      (:title "100phlecs"))
     (:body
      (:main
       (:h1 "100phhhlecs")
       (component-test))))))

(phl-index)

(defmacro with-page ((&key title) &body body)
  `(spinneret:with-html-string
     (:doctype)
     (:html
      (:head
       (:title ,title)
       (:meta :attrs (list :name "viewport"  :content "width=device-width, initial-scale=1"))
       (:link :attrs (list :rel "stylesheet"  :href "normalize.css"))
       (:link :attrs (list :rel "stylesheet"  :href "custom.css"))
       (:link :attrs (list :rel "stylesheet"  :href "iosevka-curly.css")))
      (:body ,@body))))

(defun index-html () 
  (with-page (:title "100phlecs")
    (:h1 "Thoughts")
    (li-from-list
     (funcall 'list-thoughts))
    (:footer "100phlecs")))

(defun write-html (filename content)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (write-sequence content out)))

(defun li-from-list (my-list)
  (spinneret:with-html
    (:ul
     (dolist (filename my-list)
       (:li
        (:a :href
            (uiop:strcat "thoughts/" filename)
            (get-friendly-title filename)))))))
;; * TODO read the top of the org file.
;;  also find better integration w/ org from cl
(setf friendly-title-pairs
      '(("decisions.html" "A path to calm")
        ("grab.html" "Learn before tooling")
        ("rose-tinted.html" "Rose-colored software")
        ("local-knowledge.html" "Losing your mind")))

(defun get-friendly-title (html-file)
  (second (find-if #'(lambda (pair)
                       (equal html-file (first pair))) friendly-title-pairs)))

(defun do-li (a-list)
  (spinneret:with-html
    (dolist (filename a-list)
      (:p filename))))

(defun list-thoughts ()
  (mapcar 'file-namestring (directory "../thoughts/*.html")))
(list-thoughts)

(write-html "~/common-lisp/100phlecs/index.html" (funcall 'index-html))

