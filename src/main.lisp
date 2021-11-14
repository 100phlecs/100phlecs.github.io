(defpackage 100phlecs
  (:use :cl))
(in-package :100phlecs)


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
       (:link :attrs (list :rel "stylesheet"  :href "custom.css"))
       (:link :attrs (list :rel "stylesheet"  :href "iosevka-curly.css")))
      (:body ,@body))))

(defun index-html () 
  (with-page (:title "100phlecs")
    (:h1 "Hello test")))

(write-html "~/repos/100phlecs/index-test.html" (funcall 'index-html))

(defun component-test ()
  (spinneret:with-html
    (:p (:span "hello"))))
(component-test)

(defun write-html (filename content)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (write-sequence content out)))

