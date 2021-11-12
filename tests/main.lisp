(defpackage 100phlecs/tests/main
  (:use :cl
        :100phlecs
        :rove))
(in-package :100phlecs/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :100phlecs)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
