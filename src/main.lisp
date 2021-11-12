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

(defun component-test ()
  (spinneret:with-html
    (:p (:span "hello"))))
(component-test)
(defun write-html (filename content)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (write-sequence content out)))

