import math

import numpy as np


def derivative(f, x, i, delt=0.0001):
    x_1 = np.copy(x)
    x_2 = np.copy(x)
    x_1[i] += delt
    x_2[i] -= delt
    y_1 = f(x_1)
    y_2 = f(x_2)
    return (y_1 - y_2) / (2 * delt)


def grad(f, delt=0.01):
    def grad_calc(x):
        array = []
        for i in range(len(x)):
            array.append(derivative(f, x, i, delt))
        return np.array(array)

    return grad_calc


def jacobian(funcs):
    def calc(point):
        return np.array([[derivative(funcs[i], point, j) for j in range(len(point))] for i in range(len(funcs))])

    return calc


def get_R(point, funcs):
    result = []
    for i in range(len(funcs)):
        result.append(funcs[i](point))
    return np.array(result)


def gauss_newton(cur_point, funcs, max_steps=10000, store_points=False):
    points = [np.copy(cur_point)]
    cur_point = np.array(cur_point)
    x_prev = cur_point
    J_func = jacobian(funcs)
    f = lambda x: sum([funcs[k](x) ** 2 for k in range(len(funcs))]) / 2
    for i in range(max_steps):
        J = J_func(cur_point)
        p = - np.linalg.inv(J.T @ J) @ J.T @ get_R(cur_point, funcs)
        phi = lambda a: f(cur_point + a * p)
        alpha = dichotomy(phi, 0., right_border_calc(phi))
        cur_point = cur_point + alpha * p
        if np.linalg.norm(cur_point - x_prev) < 0.00001:
            break
        x_prev = cur_point

        if store_points:
            points.append(np.copy(cur_point))

    if store_points:
        return points
    else:
        return [cur_point, f(cur_point)]


def hessian(f):
    def calc(x):
        B = np.asarray([[0. for _ in range(len(x))] for _ in range(len(x))])
        for i in range(len(x)):
            for j in range(len(x)):
                B[i][j] = derivative(lambda x_tmp: derivative(f, x_tmp, j), x, i)
        return B

    return calc


def trust_region(f, x_k, get_p, recalc_m, delta=1., delta_max=10., eps=0.001, eta=0.2,
                 max_steps=1000, store_points=False):
    div_eps = 0.00001
    g = grad(f)
    B = hessian(f)
    points = [np.copy(x_k)]
    for k in range(max_steps):
        p_k = get_p(f, g, B, x_k, delta)
        m_k = recalc_m(f, g, B, x_k)
        ro_k = (f(x_k) - f(x_k + p_k)) / (m_k(np.zeros(len(x_k))) - m_k(p_k) + div_eps)
        if ro_k < 0.25:
            delta *= 0.25
        else:
            if ro_k > 0.75 and abs(np.linalg.norm(p_k) - delta) < eps:
                delta = min(2 * delta, delta_max)
        if ro_k > eta:
            if abs(f(x_k) - f(x_k + p_k)) < eps:
                break
            x_k += p_k

            if store_points:
                points.append(np.copy(x_k))

    if store_points:
        return points
    else:
        return [x_k, f(x_k)]


def m_for_dogleg(f, g, B, x_k):
    return lambda p: f(x_k) + g(x_k).T @ p + 0.5 * p.T @ B(x_k) @ p


def p_by_dogleg(f, g, B, x_k, delta_k):
    grad_k = g(x_k)
    B_k = B(x_k)
    p_b = -np.linalg.inv(B_k) @ grad_k

    if np.linalg.norm(p_b) <= delta_k:
        return p_b

    p_u = -((grad_k.T @ grad_k) / (grad_k.T @ B_k @ grad_k)) * grad_k

    if np.linalg.norm(p_u) <= delta_k:
        p_delt = p_b - p_u
        a = np.linalg.norm(p_delt)
        b = 2 * p_delt.T @ p_u
        c = np.linalg.norm(p_u) - (delta_k ** 2)
        D = (b ** 2 - 4 * a * c)
        if D < 0:
            D = 0
        sqrt_d = math.sqrt(D)
        alpha = (-b + sqrt_d) / (2 * a)
        return p_u + p_delt * alpha
    else:
        return -(delta_k * (grad_k / np.linalg.norm(grad_k)))


def dogleg(f, x_k, delta=1., delta_max=10., eps=0.001, eta=0.2, max_steps=1000, store_points=False):
    return trust_region(f, x_k, p_by_dogleg, m_for_dogleg, delta, delta_max, eps, eta,
                        max_steps, store_points)


wolfe_cond_template = lambda c1, c2, x, func, gk: lambda a, b: not (
        (func(x - ((a + b) / 2) * gk) <= (func(x) + c1 * ((a + b) / 2) * np.dot(gk, -gk))) and (
            np.dot(grad(func)(x - ((a + b) / 2) * gk), -gk) >= c2 * np.dot(gk, -gk)))

wolfe_cond = lambda: ""


def dichotomy(func, a_1, a_2, eps=0.01, delt=0.0001, is_wolfe=False):
    cond = lambda a, b: abs(a - b) >= eps
    if is_wolfe:
        cond = wolfe_cond
    while cond(a_1, a_2):
        new_a_1 = (a_1 + a_2) / 2 - delt
        new_a_2 = (a_1 + a_2) / 2 + delt
        fv1 = func(new_a_1)
        fv2 = func(new_a_2)
        if fv2 > fv1:
            a_2 = new_a_2
        elif fv2 < fv1:
            a_1 = new_a_1
        else:
            a_1 = new_a_1
            a_2 = new_a_2
    return (a_1 + a_2) / 2


def right_border_calc(func):
    right_start = 0.0000001
    zero = func(0)
    while zero >= func(right_start):
        right_start *= 1.2

    return right_start


def bfgs(f, x, breaking_eps=0.0001, store_points=False):
    global wolfe_cond
    points = [np.copy(x)]
    I = np.eye(len(x))

    grad_prev = 0
    x_prev = 0
    H = np.copy(I)

    for k in range(1000):
        grad_tmp = np.array(grad(f)(x))
        y_k = np.array(grad_tmp - grad_prev)
        grad_prev = np.copy(grad_tmp)
        s_k = np.array(x - x_prev)
        ro_k = 1 / (y_k.T @ s_k)

        if k != 0:
            H = (I - ro_k * s_k @ y_k.T) @ H @ (I - ro_k * y_k @ s_k.T) + ro_k * s_k @ s_k.T
        p = np.array(-H @ grad_prev)
        x_prev = np.copy(x)
        wolfe_cond = wolfe_cond_template(0.001, 0.999, x, f, grad_prev)
        phi = lambda a: f(x + a * p)
        x += dichotomy(phi, 0., right_border_calc(phi), is_wolfe=False) * p

        if store_points:
            points.append(np.copy(x))

        if np.linalg.norm(x_prev - x) < breaking_eps:
            break

    if store_points:
        return points
    else:
        return [x, f(x)]


def lbfgs(f, x, breaking_eps=0.00001, m=10, store_points=False):
    global wolfe_cond
    points = [np.copy(x)]

    prev_y = []
    prev_s = []
    prev_ro = []
    size = 0
    grad_prev = 0
    x_prev = 0
    gamma = 1.

    eps_divide = 0.00001

    for k in range(1000):
        grad_tmp = np.array(grad(f)(x))
        y_k = np.array(grad_tmp - grad_prev)
        grad_prev = np.copy(grad_tmp)
        s_k = np.array(x - x_prev)
        ro_k = 1 / ((y_k.T @ s_k) + eps_divide)

        # if k != 0:
        #     prev_y.append(y_k)
        #     prev_s.append(s_k)
        #     prev_ro.append(ro_k)
        #     size = size + 1
        #     if size == m + 1:
        #         prev_y.pop(0)
        #         prev_s.pop(0)
        #         prev_ro.pop(0)
        #         size = size - 1
        #     gamma = (s_k.T @ y_k) / ((y_k.T @ y_k) + eps_divide)

        q = grad_prev
        for i in range(size):
            alpha_i = prev_ro[size - 1 - i] * prev_s[size - 1 - i].T @ prev_y[size - 1 - i]
            q = q - alpha_i * prev_y[size - 1 - i]
        r = gamma * q
        for i in range(size):
            beta_i = prev_ro[i] * prev_y[i].T @ r
            alpha_i = prev_ro[i] * prev_s[i].T @ prev_y[i]
            r = r + prev_s[i] * (alpha_i - beta_i)
        p = -r

        x_prev = np.copy(x)
        wolfe_cond = wolfe_cond_template(0.000001, 0.999999, x, f, grad_prev)
        phi = lambda a: f(x + a * p)
        x += dichotomy(phi, 0., right_border_calc(phi), is_wolfe=True) * p

        if k != 0:
            prev_y.append(y_k)
            prev_s.append(s_k)
            prev_ro.append(ro_k)
            size = size + 1
            if size == m + 1:
                prev_y.pop(0)
                prev_s.pop(0)
                prev_ro.pop(0)
                size = size - 1
            gamma = (s_k.T @ y_k) / ((y_k.T @ y_k) + eps_divide)

        if store_points:
            points.append(np.copy(x))

        if np.linalg.norm(y_k) < breaking_eps:
            break

    if store_points:
        return points
    else:
        return [x, f(x)]
