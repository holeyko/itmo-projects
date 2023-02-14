; -------------------------Functional expression-------------------------
(defn variable [name]
  (fn [vars] (get vars name)))

(defn constant [value]
  (fn [vars] value))

(defn operation_constr [f]
  (fn [& args]
    (fn [vars]
      (let [evaluate (fn [expr_el] (expr_el vars))]
        (apply f (mapv evaluate args))))))

(def add (operation_constr +))

(def subtract (operation_constr -))

(def multiply (operation_constr *))

(def divide
  (let [my_d (fn [left right]
               (cond
                 (zero? right) ##Inf
                 :else (/ left right)))]
    (operation_constr my_d)))

(def negate (operation_constr -))

(def pow
  (let
    [my_pow (fn [num power] (Math/pow num power))]
    (operation_constr my_pow)))

(def log
  (let
    [my_log (fn [foot num] (/ (Math/log (Math/abs num)) (Math/log (Math/abs foot))))]
    (operation_constr my_log)))

(def operations
  {'+      add
   '-      subtract
   '*      multiply
   '/      divide
   'negate negate
   'pow    pow
   'log    log})

(defn parseFunction [str]
  (let [
        parse_oper (fn [el] (get operations el))
        parse_expr (fn func [expr] (cond
                                     (symbol? expr) (variable (name expr))
                                     (number? expr) (constant expr)
                                     :else (apply (parse_oper (first expr)) (map func (rest expr)))))
        ]
    (parse_expr (read-string str))))


; -------------------------Object expression-------------------------

