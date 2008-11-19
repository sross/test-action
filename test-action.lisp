;; Copyright (c) 2008 Sean Ross
;; 
;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use,
;; copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following
;; conditions:
;; 
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.
;;
(in-package :sysdef)

(defclass test-action (source-file-action)
  ((name :accessor name-of :initarg :name))
  (:default-initargs :needs '(load-action)))

(export 'test-action)
(defvar *tested-system* nil)

(defmethod action-done-p ((action test-action) (comp component))
  nil)

(defgeneric create-test-module-for (module name)
  (:method ((module module) name)
   (if name
       (create-component module "tests" 'module `((:components ,name)))
       (create-component module "tests" 'wildcard-module))))

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
