(defn vec_op_constr [func]
      (fn [el1 el2]
          {:pre [(== (count el1) (count el2))]}
          (mapv func el1 el2))
      )

(def v+
  (vec_op_constr +))

(def v-
  (vec_op_constr -))

(def v*
  (vec_op_constr *))

(def vd
  (vec_op_constr /))

(defn scalar [v1 v2]
      (reduce + (v* v1 v2)))

(defn vect [v1 v2]
      {:pre [(and (== (count v1) 3) (== (count v2) 3))]}
      (vector
        (- (* (get v1 1) (get v2 2)) (* (get v1 2) (get v2 1)))
        (- (* (get v1 2) (get v2 0)) (* (get v1 0) (get v2 2)))
        (- (* (get v1 0) (get v2 1)) (* (get v1 1) (get v2 0)))
        ))

(defn *s_constr [func]
      (fn [v s]
          (mapv (fn [x] (func x s)) v)))

(def v*s
  (*s_constr *))

(def m+
  (vec_op_constr v+))

(def m-
  (vec_op_constr v-))

(def m*
  (vec_op_constr v*))

(def md
  (vec_op_constr vd))

(def m*s
  (*s_constr v*s))

(defn transpose [m]
      (apply mapv vector m))

(defn m*v [m v]
      (mapv (fn [row] (scalar row v)) m))

(defn m*m [m1 m2]
      {:pre [(== (count (first m1)) (count m2))]}
      (mapv (
              fn [row1]
                 (mapv (
                         fn [row2]
                            (scalar row1 row2)
                            ) (transpose m2))
                 ) m1))

(defn s_constr [func_number]
  (fn func [v1 v2]
    (cond
      (and (number? v1) (number? v2)) (func_number v1 v2)
      :else (mapv func v1 v2))))

(def s+
  (s_constr +))

(def s-
  (s_constr -))

(def s*
  (s_constr *))

(def sd
  (s_constr /))