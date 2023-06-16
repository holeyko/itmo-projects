import random
import tracemalloc
from math import cos, pi
from time import time

import numpy as np
from matplotlib import pyplot as plt

from excel import ExcellSaver
from linreg import sgd_handler, Methods, visualise_approximation, gen_linear_reg, LearningRateScheduling
from main import dogleg, gauss_newton, bfgs, lbfgs


class Metrics:
    def __init__(self, mem, steps, time):
        self.mem = mem
        self.points = steps
        self.time = time


def visualise(f, points, title, x_label="x", y_label="y"):
    values = np.transpose(points)
    X = np.linspace(min(values[0]) - 10, max(values[0]) + 10, 100)
    Y = np.linspace(min(values[1]) - 10, max(values[1]) + 10, 100)
    Z = [[f(np.array([X[i], Y[j]])) for i in range(len(X))] for j in range(len(Y))]
    plt.contour(X, Y, Z, 50)

    plt.plot(values[0], values[1], marker='.')
    plt.plot(values[0][0], values[1][0], 'og')
    plt.plot(values[0][-1], values[1][-1], 'or')
    plt.title(title)
    plt.legend(['Optimization', 'Start point', 'End point'])
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.show()


def str_func(coeffs, powers):
    res = ''
    for i in range(len(coeffs)):
        if powers[i] == 0:
            res += '1'
        else:
            res += 'x^' + str(powers[i])

        if i != len(coeffs) - 1:
            res += ' + '

    return res


def get_metrics(func):
    start = time()
    tracemalloc.start()
    steps = func()
    mem = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    end = time()

    return Metrics(mem, steps, end - start)


def refresh_linreg(linreg, start_x):
    linreg.W = np.copy(start_x)
    linreg.W_points = [np.copy(linreg.W)]


def linreg_comparing(linreg_func, title, sheet_title, visualize_prev_methods=True):
    global excel_saver

    excel_saver.add_new_sheet(["method", "count steps", "function", "loss", "memory", "time"], sheet_title)

    count_2d_examples = 100
    count_other_examples = 100
    count_points = random.randint(50, 100)
    linregs_examples = []
    for i in range(count_2d_examples + count_other_examples):
        count_variables = 2 if i < count_2d_examples else random.randint(3, 6)
        linregs_examples.append((
            gen_linear_reg(count_variables - 1, count_points, -2., 2., -2., 2., 2.),
            str_func([1. for _ in range(count_variables)], [float(k) for k in range(count_variables)])
        ))
    lr = lambda *args: 0.1

    for linreg, f_str in linregs_examples:
        start_x = np.array([float(random.randint(5, 20)) for _ in range(len(linreg.W))])
        refresh_linreg(linreg, start_x)
        metrics = get_metrics(lambda: linreg_func(np.copy(start_x), linreg))

        linreg.W = metrics.points[-1]
        linreg.W_points = metrics.points
        excel_saver.add_row(
            [title, len(metrics.points), f_str, linreg.loss(metrics.points[-1]), metrics.mem, metrics.time])
        if len(linreg.W) == 2:
            visualise(linreg.loss, linreg.W_points, title, "w_1", "w_2")
        visualise_approximation(linreg, title)

        if visualize_prev_methods:
            for method in Methods:
                def sgd_caller():
                    if method == Methods.AdaGrad or method == Methods.RMSprop or method == Methods.Adam:
                        sgd_handler(linreg, lr, method, store_points=True)
                    else:
                        sgd_handler(linreg, lr, method, lrs=LearningRateScheduling.Stepwise, store_points=True)
                    return linreg.W_points

                refresh_linreg(linreg, start_x)
                metrics = get_metrics(sgd_caller)

                excel_saver.add_row([
                    method, len(metrics.points), f_str, linreg.loss(metrics.points[-1]),
                    metrics.mem, metrics.time
                ])
                if len(linreg.W) == 2:
                    visualise(linreg.loss, linreg.W_points, method.name.replace("Methods.", ""), "w_1", "w_2")
                visualise_approximation(linreg, method.name.replace("Methods.", ""))


def gauss_newton_vs_prev(visualize_prev_methods=True):
    global excel_saver

    def calc_points(start_x, linreg):
        funcs = np.array([lambda W, i=i: np.dot(linreg.T[i], W) - linreg.Y[i] for i in range(len(linreg.X))])
        return gauss_newton(start_x, funcs, store_points=True)

    linreg_comparing(calc_points, "Gauss-Newton", "Gauss-Newton vs Prev", visualize_prev_methods=visualize_prev_methods)


def dogleg_vs_prev(visualize_prev_methods=True):
    global excel_saver

    def calc_points(start_x, linreg):
        return dogleg(linreg.loss, start_x, store_points=True)

    linreg_comparing(calc_points, "Dogleg", "Dogleg vs Prev", visualize_prev_methods=visualize_prev_methods)


def bfgs_vs_prev(visualize_prev_methods=True):
    global excel_saver

    def calc_points(start_x, linreg):
        return bfgs(linreg.loss, start_x, store_points=True)

    linreg_comparing(calc_points, "BFGS", "BFGS vs Prev", visualize_prev_methods=visualize_prev_methods)


def lbfgs_vs_prev(visualize_prev_methods=True):
    global excel_saver

    def calc_points(start_x, linreg):
        return dogleg(linreg.loss, start_x, store_points=True)

    linreg_comparing(calc_points, "LBFGS", "LBFGS vs Prev", visualize_prev_methods=visualize_prev_methods)


def comparing_between(funcs, methods, titles, is_array_funcs=False):
    global excel_saver

    for f in funcs:
        start_x = [float(random.randint(30, 100)), float(random.randint(30, 100))]
        for i in range(len(methods)):
            metrics = get_metrics(lambda: methods[i](f, np.copy(start_x)))
            real_func = (lambda x: sum([f[i](x) ** 2 for i in range(len(f))])) if is_array_funcs else f
            excel_saver.add_row(
                [titles[i], len(metrics.points), real_func(metrics.points[-1]), metrics.mem, metrics.time])
            visualise(real_func, metrics.points, titles[i])


def gauss_newton_vs_others():
    global excel_saver

    excel_saver.add_new_sheet(["method", "count steps", "function value", "memory", "time"], "Gauss Newton vs Others")
    comparing_between(
        [
            [lambda x: x[0] - 5, lambda x: x[1] + 6],
            [lambda x: x[0] * (x[0] + 3 * x[1]) + x[1] * (3 - x[0]),
             lambda x: (x[0] + 2) + x[1] * (4 - x[0] * 4) + x[1] * 3],
            [lambda x: (x[0] + 4) + (x[1] * 2 + x[0] - 9), lambda x: x[0] * 2 + x[1] + (x[0] - 3)],
            [lambda x: 1 - x[0], lambda x: 10 * (x[1] - x[0] * 2)]
        ],
        [
            lambda funcs, start_x: gauss_newton(start_x, funcs, store_points=True),
            lambda funcs, start_x: dogleg(lambda x: sum([funcs[i](x) ** 2 for i in range(len(funcs))]), start_x,
                                          store_points=True),
            lambda funcs, start_x: bfgs(lambda x: sum([funcs[i](x) ** 2 for i in range(len(funcs))]), start_x,
                                        store_points=True),
            lambda funcs, start_x: lbfgs(lambda x: sum([funcs[i](x) ** 2 for i in range(len(funcs))]), start_x,
                                         store_points=True)
        ],
        ["Gauss Newton", "Dogleg", "BFGS", "LBFGS"], is_array_funcs=True
    )


def dogleg_vs_bfgs_vs_lbfgs():
    excel_saver.add_new_sheet(["method", "count steps", "function value", "memory", "time"], "Dogleg vs BFGS vs LBFGS")
    comparing_between(
        [
            lambda x: x[0] ** 2 + 2 * x[1] ** 2 - 0.3 * cos(3 * pi * x[0]) - 0.4 * cos(4 * pi * x[1]) + 0.7,
            lambda x: x[0] ** 2 + 2 * x[1] ** 2 - 0.3 * cos(3 * pi * x[0] + 4 * pi * x[1]) + 0.3,
            lambda x: sum(
                [sum([(j + 1.3) * (x[j] ** (i + 1) - (1 / ((j + 1) ** (i + 1)))) for j in range(2)]) ** 2 for i in
                 range(2)])
        ],
        [
            lambda f, start_x: dogleg(f, start_x, store_points=True),
            lambda f, start_x: bfgs(f, start_x, store_points=True),
            lambda f, start_x: lbfgs(f, start_x, store_points=True)
        ],
        ["Dogleg", "BFGS", "LBFGS"]
    )


excel_saver = ExcellSaver()
gauss_newton_vs_prev()
dogleg_vs_prev()
bfgs_vs_prev()
lbfgs_vs_prev()
gauss_newton_vs_others()
dogleg_vs_bfgs_vs_lbfgs()
excel_saver.create_excel("metrics.xlsx")
