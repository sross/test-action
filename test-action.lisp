(in-package :sysdef)

(defclass test-action (source-file-action)
  ((name :accessor name-of :initarg :name))
  (:default-initargs :needs '(load-action)))

(export 'test-action)
(defvar *tested-system* nil)

(defmethod action-done-p ((action test-action) (comp component))
  nil)

(defmethod create-test-module-for ((module module) name)
  (if name
      (create-component module "tests" 'module `((:components ,name)))
      (create-component module "tests" 'wildcard-module)))

(defmethod execute ((module module) (action test-action))
  (let ((*tested-system* module))
    (execute (create-test-module-for module (name-of action))
             'load-action)))


#|
(execute (find-system :cl-store) 'test-action)

test-action module
  -> load all files in module-pathname/test

test-action module &key name
  -> compile and load load  module-pathname/test/name
|#
