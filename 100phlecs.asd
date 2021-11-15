(defsystem "100phlecs"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:spinneret)
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "100phlecs/tests"))))

(defsystem "100phlecs/tests"
  :author ""
  :license ""
  :depends-on ( :100phlecs
                :rove
                :spinneret)
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for 100phlecs"
  :perform (test-op (op c) (symbol-call :rove :run c)))
