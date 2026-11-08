# ELEC2103 期末复习 — 知识点 + Checkpoints

> **目标**：掌握 ≥70% 知识点，并能写出考试风格的 MATLAB 脚本
> **来源**：W1–3、W5–12 lecture slides + Week 6 Main Quiz + **W13 tutorial 划重点的 5 道题（Part T）**（W4 的 eig/SVD slides 不在材料里，eig 部分在 Part B5 / Part I 补上）
> **答案**：每个 CP 的答案都折叠在 `答案` 里，先自己做再展开。Part A–K 的数值答案用 Octave 跑过核对；Part T 的数值用 Python（SymPy / SciPy）核对过，但 Part T 的 MATLAB 代码**没有在 MATLAB 里实际运行**。
> **v2（2026-11-04）**：新增 Part T；与 W13 tutorial 相关的 KP 标了 🎯 并提高了星级；另外改正了 3 处，见本节末尾的"v2 改动"。
> **v3（2026-11-05）**：新增 Part 0（MATLAB 语法速成），末尾附可以直接抄到 cheatsheet 上的速查块。

---

## 0. 怎么用这份文件

### 星级

| 标记 | 含义 | 建议 |
|---|---|---|
| 🎯 | W13 tutorial 划重点的 5 道题直接用到 | **最先保证**；Part T 的原题要能独立写出 |
| ★★★ | 核心，要能**直接写出代码** | 每个 CP 都要亲手敲一遍 |
| ★★ | 要理解 + 会用，可能作为小问出现 | 看懂答案、能复述 |
| ★ | 知道存在即可 | 扫一眼 |

**70% 路线**：附录 C 最后一行列出的 CP，覆盖全部 🎯 KP 和大部分 ★★★ KP。这是按**知识点个数**估的，不能换算成考试分数。

### 考法判断（置信度：中等）

依据是一份 Week 6 quiz，加上 W12 slide 末尾说下周讲 "exam example questions"。

Week 6 quiz 的结构是：

1. **用个人参数生成数据**（生日 D、月份 M、学号和 S）
2. **建模**（构造矩阵 / 方程 / 系统）
3. **用指定方法求解**（指定了 `qr`，不能随便换成 `\`）
4. **`disp` 带清晰标签输出结果**
5. **专业作图**（scatter + 曲线 + title + xlabel/ylabel + legend）—— 这一项单独 20/50 分

**W13 tutorial（11-03）补充的信号**：最后一节 tutorial 讲了 5 道题——symsum 级数、无导数 Newton、Lotka-Volterra（ode45 + 相平面）、相量 + Laplace 电路分析、多节点电路联立 `dsolve`。题型都是"工程场景 → 写 MATLAB 程序 → 作图"，和 Week 6 quiz 一致。我把它当作比旧 lab 更强的"今年考什么"的信号，但不等于原题一定出现（置信度中等）。

所以每个 Part 的 CP 都尽量写成"能独立跑的脚本"；Part T 收了 tutorial 的 5 道原题，Part K 是三道同风格的综合模拟题。

**考试可以带 cheatsheet**：语法和函数名不用背，重点是看懂代码、会改模板。Part 0 末尾的速查块、附录 A（函数速查）和附录 B（常见坑）都可以直接抄上去。

### 取舍（砍掉 / 降级了什么）

- **砍掉**：`help`/`lookfor`/编辑器界面、OOP/调用 C·Java·Python、MuPAD 历史、beta/Dirichlet 复合分布、t/F/χ² 假设检验、logistic 回归的极大似然推导、SVD（W4 slides 没给）
- **降级为 ★**：cell/struct 细节、`xlsread`/`textscan` 具体参数、Cholesky/LDL、多项分布
- **补充（slides 只提了一句但做题需要）**：Euler/RK4 公式（W10 outline 里有）、Markov 链稳态（W5 说 lab 会用 eig 做）、二维 Newton 的正确 MATLAB 写法、**联立 ODE 的 `dsolve` 和差商 Newton（W13 tutorial）**

### Lecture slides 里的 typo / bug（复习时别被带偏）

| 位置 | slides 写的 | 正确的 |
|---|---|---|
| W3 式(3) | `w = R(Q⁻¹y)` | $w = R^{-1}(Q^T y)$，MATLAB：`w = R\(Q'*y)` |
| W5 Weibull pdf | 指数写成 $(x/a)^k$ | $(x/a)^b$ |
| W6 descriptive stats | `prctile(y1,[0,25,50,75,1000])` | 最后一个应为 `100` |
| W6 多项式拟合循环 | `b(n) = {M\y}`，`n` 从 0 开始 | 索引不能为 0，且会重复加一列全 1（见 CP D5） |
| W7 `simplify` 输出 | `(2 + 4*x + 3)/(x + 2)` | `(x^2 + 4*x + 3)/(x + 2)` |
| W8 多维 Newton | `x_{n+1} = x_n − f(x_n)/J(x_n)` | $x_{n+1} = x_n - J^{-1}f$，MATLAB：`x = x - J\F` |
| W10 非自治例子 | 公式 `−cos(2t)`，代码 `−2*cos(t)` | 两者不一致，以题目为准 |
| W10 ode45 例子 | 标量 ODE 给初值 `[0,x0]`，画 `txSol(:,2)` | **不是 bug**（v1 判错了）。右端 `x.^2 - x` 是逐元素运算，传进 2×1 就返回 2×1，ode45 等于并排解了两份同一个方程：第一份从平衡点 0 出发，一直是 0；第二列才是要的解。能跑，结果也对，只是写法绕。自己写时标量方程直接给 `x0` 最清楚 |
| W11 $\lvert Z\rvert$ | `A R² + (jωL − ωL)²` | $\lvert Z\rvert = \sqrt{R^2 + (\omega L - \tfrac{1}{\omega C})^2}$ |
| W12 SS 例子 | 矩阵写 `−20`，代码写 `−10` | 对应 $s^3+4s^2+14s+20$ 应是 `−20` |
| W12 TF 函数 | `Z1 = R + sL` | `Z1 = R + s*L` |
| W2 `cellfun(@max, C)` 含空数组 | 说返回 `10 6 NaN` | 实际会报错，需要 `'UniformOutput', false`（Octave 实测报错；MATLAB 行为相同的把握约 85%） |

### 学习时长预估与计划

> 前提：每个 CP 都**在 MATLAB 里亲手敲**，不是只看答案。估计按你已有的线代（MATH2061）、电路（ELEC2100）、编程基础打了折扣。误差大约 ±30%，卡在 MATLAB 语法上会偏长（先做 Part 0 可以减少这种情况）。

| Part | 内容 | CP 数 | 预估 | 说明 |
|---|---|---|---|---|
| **0** | **MATLAB 语法速成** | 3 | 1 h | 最先做；看懂答案代码的前提 |
| **T** | **W13 tutorial 5 题 🎯** | 5 | 3 h | **权重最高**；卡住就跳到对应 KP 补完再回来 |
| A | MATLAB 基础 | 9 | 1.5 h | 有编程基础，主要是熟悉语法 |
| B | LU / QR / 最小二乘 | 8 | 3 h | **B4b 要能迁移到别的基函数**，多花时间 |
| E | 符号计算 | 8 | 2 h | 后面所有 Part 都要用，提前学 |
| F | 非线性方程 | 7 | 2 h | Newton 要能手写循环（含差商版） |
| G | ODE 解析 + 相量 | 7 | 2 h | 电路部分是 ELEC2100 复习 |
| H | ODE 数值 + RLC 暂态 | 9 | 3 h | ode45 / 状态方程是重点 |
| I | 稳定性 / 频响 / Laplace | 6 | 2.5 h | |
| J | LTI 系统 | 8 | 2.5 h | tf / ss / step / bode |
| C | 概率 | 5 | 1.5 h | 独立模块，参数坑多 |
| D | 统计与 ML | 6 | 1.5 h | 很多和 B 重叠 |
| K | 三道模拟题 | 3 | 3 h | 每道限时 40 min + 对答案 |
| | **全部** | **84** | **≈ 28–29 h** | |
| | **最低 70% 路线**（附录 C 最后一行） | 42 | **≈ 16–18 h** | |

**学习顺序**：先花 1 小时做 Part 0。之后 Part T 权重最高，但它用到 E/F/G/H/I 的内容，有两种做法：

1. **时间够**：按依赖关系 A → B → E → F → G → H → I → J → C → D → K 学，每学完 T 题需要的那个 Part，就马上做对应的 T 题（下面的排期就是这样排的）
2. **时间很紧**：直接从 Part T 开始，卡在哪就跳回那道题标注的 KP

**参考排期**（全部路线按每天 4–5 小时；70% 路线现在约 5–6 小时/天）：

| 天 | 全部路线（6 天） | 70% 路线（3 天） |
|---|---|---|
| 1 | **Part 0** + A + B | **0a 0b 0c** · A1 A2 A5 A6a A8 · B2 B4a B4b · E2a E3 E4 E5a · **T1** |
| 2 | E + F + **T1 T2** | F2a F2b F3 · **T2** · G2a G4 G5a · H3 H4 H6a H6b · **T3 T5** |
| 3 | G + H + **T3 T5** | I2a I4 I5 · **T4** · J2 J3 J5 J6 J7 · C3a C3b · D4 · Mock 1 |
| 4 | I + J + **T4** | |
| 5 | C + D | |
| 6 | Mock 1–3 + **Part T 限时重做** + 回看错题 | |

每学完一个 Part，在附录 C 的进度清单里打勾；做错的 CP 标出来，最后一天集中回看。

### v2 改动

1. 新增 **Part T**（W13 tutorial 的 5 道题）。标了 🎯 的 KP：E2、E4、F2、F4、G2、G4、G5、**G6（新增）**、H3、H4、I4、I5
2. 星级调整：E4 级数 ★★ → ★★★；F4 无导数求根 ★ → ★★★（差商 Newton 部分，新增 CP F4b）；新增 G6 多节点电路联立 ODE ★★★；H1 加了"时间图 vs 相平面图"的区分
3. 改正：
   - 删掉"★★★ ≈ 课程内容 70%"和"几乎必考"的说法，这两句没有依据
   - W10 `ode45` 初值 `[0,x0]` 不是 bug，v1 判错了（见上表）
   - CP B4b 的验收标准从"默写原题"改成"换了基函数、数据和参数，仍能自己写出"

### v3 改动

- 新增 **Part 0**（MATLAB 语法速成）：讲答案代码里反复出现的写法（三种括号、冒号、函数句柄、成对的选项参数、作图状态、`fprintf`、符号 vs 数值、读报错），3 个 CP，末尾附 cheatsheet 速查块

---

## 目录

- [Part 0 — MATLAB 语法速成：看懂答案里的代码](#part-0--matlab-语法速成看懂答案里的代码)
- [Part T — W13 Tutorial 划重点（5 道原题）🎯](#part-t--w13-tutorial-划重点5-道原题)
- [Part A — MATLAB 基础（W1–2）](#part-a--matlab-基础w12)
- [Part B — 线性代数：LU / QR / 最小二乘（W3 + W6 quiz）](#part-b--线性代数lu--qr--最小二乘w3--w6-quiz)
- [Part C — 概率模型（W5）](#part-c--概率模型w5)
- [Part D — 统计与机器学习（W6）](#part-d--统计与机器学习w6)
- [Part E — 符号计算（W7）](#part-e--符号计算w7)
- [Part F — 非线性方程（W8）](#part-f--非线性方程w8)
- [Part G — ODE 解析解 + 电路 + 相量（W9）](#part-g--ode-解析解--电路--相量w9)
- [Part H — ODE 数值解 + RLC 暂态（W10）](#part-h--ode-数值解--rlc-暂态w10)
- [Part I — 稳定性 / AC 频响 / Laplace（W11）](#part-i--稳定性--ac-频响--laplacew11)
- [Part J — LTI 系统（W12）](#part-j--lti-系统w12)
- [Part K — 综合模拟题（考试风格）](#part-k--综合模拟题考试风格)
- [附录 — 速查表 / 常见坑 / 进度清单](#附录)

---

## Part 0 — MATLAB 语法速成：看懂答案里的代码

> **目标**：答案里的每一行代码都能说出是什么意思，并且会改。**不用背**：考试可以带 cheatsheet，本节最后有一块可以直接抄上去的速查。
> **默认你已经会**：变量赋值、`if`/`for`、四则运算。这里只讲后面答案里反复出现、Part A 又没讲清楚的写法。
> 类比用 Python（你写过）。每个小节都标了"在哪见过"，可以对照 Part T 的代码看。预估 1 h。

### 0.1 一个脚本长什么样

几乎每道答案都这样开头：

```matlab
clear; clc; close all;    % 清空变量、清空命令行、关掉所有图：每题开头"清场"
%% Part 1                 % %% 开头的行 = 分节 (section)
x = 3                     % 行尾没有分号：命令行会打印出 x = 3
y = 4;                    % 行尾有分号：照样执行，只是不打印
z = x + ...
    y;                    % ... = 这行没写完，下一行接着写
```

| 符号 | 意思 | Python 里对应 |
|---|---|---|
| 行尾 `;` | **不打印结果**。不是语句结束符，忘了写不报错，只是刷屏 | 没有对应，相当于"不 print" |
| `%` | 注释 | `#` |
| `%%` | 分节。光标放在某一节里按 **Run Section**（Windows 上 Ctrl+Enter），只跑这一节 | Jupyter 的一个 cell |
| `...` | 续行 | 行尾 `\` |

**考试小技巧**：每一问开一个 `%%` 节，写完一节跑一节。报错时只需要看这一节。

**文件名的坑**：脚本存成 `.m` 文件，名字只能有字母、数字、下划线，不能以数字开头，也不能和内置函数同名。`q1_lotka.m` 可以；`Q1 answer.m`、`1q.m` 不行；取名 `ode45.m`、`plot.m` 会把真正的 `ode45`、`plot` 挡住。

---

### 0.2 三种括号：`( )` `[ ]` `{ }`

自测里最难懂的就是这部分。

**① 圆括号 `( )`：取元素，或者调用函数**。两种用法长得一样，看左边的名字是什么。

| 写法 | 左边是 | 意思 |
|---|---|---|
| `p(1)` | 变量（向量） | 取第 1 个元素。**从 1 开始数**，Python 是 `p[0]` |
| `sin(1)` | 函数 | 调用 sin，算 sin(1) |
| `W(xk)` | 函数句柄（T2） | 调用 W，算 W(xk) |
| `v1(0) == 0` | 符号函数（T5） | v1 在 t = 0 处的值等于 0（初值条件） |

**② 方括号 `[ ]` 在等号右边：拼数组**

- 逗号或空格 = 往右拼（同一行）
- 分号 = 换到下一行

```matlab
[1, 2, 3]      % 1×3 行向量
[1; 2; 3]      % 3×1 列向量
[1 2; 3 4]     % 2×2 矩阵
```

所以 T3 里的

```matlab
[ alpha*p(1) - beta*p(1)*p(2);
  delta*p(1)*p(2) - gamma*p(2) ]
```

就是把两个式子**竖着**拼成一个 2×1 列向量：第一行是 dp₁/dt，第二行是 dp₂/dt。**方括号里的 `;` 表示"换行"，和行尾表示"不打印"的 `;` 是两回事。**

⚠️ 方括号里空格也算分隔符：`[1 -2]` 是两个数 `1` 和 `-2`，`[1 - 2]` 才是 `-1`。写减法时，减号两边要么都留空格，要么都不留。

**③ 方括号在等号左边：接收多个输出**（这不是拼数组）

```matlab
[tSol, ppPop] = ode45(...)    % ≈ Python: tSol, ppPop = ode45(...)
[L, U, P] = lu(A)             % 三个输出（B2）
[m, k] = min([4 1 3])         % m = 1（最小值），k = 2（在第几个）
[~, k] = min([4 1 3])         % ~ = 这个输出我不要（≈ Python 的 _）
```

- 输出的**顺序是函数规定的**，名字随你起。`ode45` 的第一个输出永远是时间，第二个永远是解
- 只用一个变量接收时，一般只拿到第一个输出：`m = min(x)` 只有最小值，没有位置
- ⚠️ **`ode45` 是例外**：只接一个输出时，它返回一个结构体 (struct)，不是解矩阵。所以永远写 `[t, Y] = ode45(...)`

**④ 花括号 `{ }`**：cell 数组，考试基本用不到，见 KP A7。

**在哪见过**：T3 定义 `dpdt`、`[tSol, ppPop] = ode45(...)`；T5 的 `dsolve([eq1, eq2], [cond1, cond2])` 把两个方程拼成一个数组再交给 `dsolve`。

---

### 0.3 冒号 `:`：生成范围，或者取"整行 / 整列"

**用法 1：生成等差序列**

```matlab
1:5            % [1 2 3 4 5]，包含 5（Python 的 range(1, 5) 不含 5）
0:0.05:100     % 起点:步长:终点，共 2001 个点（T3 的 tYears）
10:2:20        % [10 12 14 16 18 20]
```

**用法 2：在下标里单独写一个 `:`，表示"这一维全要"**。下标顺序是 `(行, 列)`，先行后列。

```matlab
ppPop(:, 1)    % 所有行、第 1 列 = 每个时刻的兔子数（整条猎物曲线）
ppPop(:, 2)    % 所有行、第 2 列 = 猞猁
A(2, :)        % 第 2 行全部
x(end)         % 最后一个元素；end 在下标里 = "最后一个的编号"
ppPop(end, 1)  % 最后一个时刻的兔子数
```

相当于 numpy 的 `pp[:, 0]`，只是 numpy 从 0 数，MATLAB 从 1 数。

**在哪见过**：T3 画图用的 `ppPop(:,1)`；B4b 的 `A_poly(:, i+1) = X.^i`（给整一列赋值）；A1 的 `X(10:2:end)`。

---

### 0.4 函数句柄 `@`：把函数当成一个值传来传去

**解释**：`ode45`、`fzero`、`integral`、`fplot` 这类函数，要的输入不是一个数，而是**另一个函数**。比如你把"算导数的公式"交给 `ode45`，由它决定在哪些时刻、哪些状态下调用这个公式。`@` 的作用就是把一个函数打包成一个值，好当作参数传进去。

一句话定义：`f = @(参数) 表达式` 创建一个匿名函数 (anonymous function)，相当于 Python 的 `f = lambda 参数: 表达式`。

**例 1：最简单的，一个输入一个输出**

```matlab
f = @(x) x.^2 - 2;     % ≈ lambda x: x**2 - 2
f(3)                   % 7
fzero(f, [1 2])        % 把 f 整个交给 fzero，返回 1.4142
```

**例 2：ode45 要的句柄（T3 的核心）**

```matlab
dpdt = @(t, p) [ alpha*p(1) - beta*p(1)*p(2);
                 delta*p(1)*p(2) - gamma*p(2) ];
```

逐块读：

- `@(t, p)`：这个函数有两个输入，**t = 当前时刻**，**p = 当前状态**（列向量：p(1) 是兔子数，p(2) 是猞猁数）
- 右边的方括号：返回一个 2×1 列向量，也就是此刻的 [dp₁/dt; dp₂/dt]
- 右边没用到 t，为什么也要写？因为 `ode45` **每次调用都传两个参数** `dpdt(t, p)`。只写 `@(p)` 会报 `Too many input arguments`
- `alpha`、`beta` 这些值，在**定义句柄的那一刻**就被"拍照"存进去了。之后再改 `alpha = 1`，dpdt 里用的还是旧值，必须重新定义一遍 dpdt

**例 3：现成函数的句柄，以及由符号表达式生成的句柄**

```matlab
fzero(@tan, [1 2])                        % @tan = 把现成的 tan 打包成句柄（F1a）
W = matlabFunction(Ws);                   % 把符号表达式 Ws 变成数值句柄 W（T2，见 0.8）
ode45(@(t, x) A*x + B, [0 10], [0; 0])    % 句柄可以直接写在参数位置（T5 加问）
```

---

### 0.5 成对的选项参数：`'LineWidth', 1.5`

**解释**：很多函数的可选设置是**成对**写的：先写选项名（字符串），再写它的值。这种写法叫 Name-Value 参数，相当于 Python 的关键字参数 `linewidth=1.5`。几对之间的顺序随意，都放在必需参数后面。

**例 1：作图**

```matlab
plot(t, y, 'r--', 'LineWidth', 2, 'DisplayName', 'ode45')
%    x  y  线型    选项名      值   选项名         值
```

`'r--'` 不是成对参数，而是一个**线型简写**：颜色 + 线型 + 点型，可以随意组合。

| 颜色 | 线型 | 点型 |
|---|---|---|
| `b` 蓝　`r` 红　`g` 绿　`k` 黑　`m` 品红 | `-` 实线　`--` 虚线　`:` 点线 | `o` 圆圈　`.` 点　`x` 叉　`*` 星 |

`'b-'` = 蓝色实线；`'r--'` = 红色虚线；`'ko'` = 黑色圆圈，不连线。

**例 2：图的其他部分**

```matlab
figure('Color', 'white')                            % 白底画布
legend('Location', 'best')                          % 图例自动放在不挡线的位置
plot(p0(1), p0(2), 'go', 'MarkerFaceColor', 'g')    % 绿色实心圆点（T3 标出初值）
```

**例 3：和作图无关的函数也这样写**

```matlab
makedist('Normal', 'mu', 1, 'sigma', 3)     % 分布参数（C2）
cellfun(@max, C, 'UniformOutput', false)    % A7
matlabFunction(F, 'Vars', {[x; y]})         % F3
```

---

### 0.6 作图的"画布状态"：figure / hold / subplot

**解释**：MATLAB 作图有一个"当前画布"的概念。每次 `plot` 默认**先擦掉当前坐标轴，再画新的**。下面这些命令都是在改这个状态：

| 命令 | 作用 | 类比 |
|---|---|---|
| `figure` | 开一张新画布（新窗口） | 拿一张新纸 |
| `hold on` | 之后的 `plot` **叠加**上去，不擦 | 用手按住这张纸 |
| `hold off` | 恢复成"每次 plot 都先擦掉" | 松手 |
| `subplot(2,1,1)` | 把画布切成 2 行 1 列，切到第 1 格 | 把纸折成上下两半，先画上半 |
| `xlabel` `ylabel` `title` `legend` `grid on` | 作用在**当前**那一格 | — |

**例 1：一张图叠三样东西**（B4b）

```matlab
figure;
scatter(X, Y); hold on      % 先画数据点，按住
plot(X, Yp, 'r-');          % 叠上第一条
plot(X, Ys, 'g--');         % 叠上第二条
hold off
```

不写 `hold on`，图上只剩最后那条绿线（A8 的扣分点）。

**例 2：上下两张子图**（T3）

```matlab
subplot(2,1,1);                         % 切到上半
plot(tSol, ppPop(:,1)); hold on
plot(tSol, ppPop(:,2)); hold off
title('populations vs time');           % 这个 title 属于上半
subplot(2,1,2);                         % 切到下半
plot(ppPop(:,1), ppPop(:,2));           % 相平面图
title('phase plane');                   % 这个 title 属于下半
```

**例 3：`plot` 和 `fplot` 的分工**

- `plot(x, y)`：x、y 都是**数值数组**，把这些点连起来
- `fplot(f, [a b])`：f 是**函数句柄或符号表达式**，由它自己在 [a, b] 上取点（T1、T4 第 2 问、T5）

为什么要分成两个，见 0.8。

---

### 0.7 输出：disp / fprintf / sprintf

**`disp`：直接显示一个值**，不能控制格式。考试里常这样用：

```matlab
disp('Polynomial weights w_poly:'); disp(w_poly)    % 先打一行标签，再打向量
```

**`fprintf`：按格式打印**，和 C 语言的 `printf` 一样。`%` 开头的是占位符，后面的值按顺序填进去。

| 占位符 | 意思 | 例 |
|---|---|---|
| `%d` | 整数 | `14` |
| `%f` | 小数（默认 6 位） | `0.275156` |
| `%.4f` | 保留 4 位小数 | `0.2752` |
| `%e`、`%.3e` | 科学计数法 | `3.969e-15` |
| `%s` | 字符串 | — |
| `\n` | 换行。**不写的话，下一次打印会接在同一行** | — |

**例 1**（T2）

```matlab
fprintf('x = %.10f, iterations = %d\n', xk, iter);
% 输出：x = 0.2751556621, iterations = 14
```

`%.10f` 留了一个"10 位小数"的空，填 `xk`；`%d` 留了一个整数的空，填 `iter`；最后 `\n` 换行。

**例 2**（T4）

```matlab
fprintf('Y(j100) = %.4f + j%.4f S\n', real(Y100), imag(Y100));
% 输出：Y(j100) = 0.5385 + j0.6923 S
```

**例 3：`sprintf` 不打印，而是返回一个字符串**，常用来拼图的标题（T1）

```matlab
title(sprintf('Square wave (f = %d Hz, %d terms)', f, K));
% 标题：Square wave (f = 2 Hz, 10 terms)
```

⚠️ 用 `%d` 打印小数不会报错，但 MATLAB 会自动改成科学计数法显示（比如 `1.274734e+02`），很乱。小数用 `%.2f` 之类。

字符串用**单引号** `'...'`。字符串里要写单引号，就连写两个：`'y'' + y = 1'` 显示为 `y' + y = 1`（Mock 3 的标题就是这样写的）。

---

### 0.8 符号世界 vs 数值世界

**解释**：MATLAB 里同时有两套东西，很多报错都是因为把它们混着用了。

| | 数值 (double) | 符号 (sym) |
|---|---|---|
| 怎么来的 | 普通赋值、`linspace`、`ode45` 的输出 | `syms x t s k` 之后，用这些变量写出来的式子 |
| 像什么 | 计算器：每个量都是具体的数 | 草稿纸：式子一直保持公式的样子（≈ Python 的 SymPy） |
| 能用的函数 | `plot` `ode45` `fzero` `semilogx` `fprintf` | `diff` `int` `solve` `dsolve` `symsum` `laplace` `ilaplace` `subs` `simplify` |
| 作图 | `plot(x, y)` | `fplot(expr, [a b])` |

**从符号世界到数值世界的两种方法**（反方向用 `sym(1/3)`，很少用）：

```matlab
double(subs(expr, t, 0.125))    % 符号 → 一个数：先代入，再转成 double（T1 自检）
g = matlabFunction(expr);       % 符号 → 数值句柄，之后 g(0.3)、g(数组) 都能算（T2）
```

怎么看一个变量属于哪个世界：看 Workspace 窗口的 Class 列（`sym` 还是 `double`），或者输入 `class(x)`。

**例 1：T1 全程在符号世界**。`symsum` 得到符号表达式，直接用 `fplot` 画。写成 `plot(t, xsqr)` 会报错，因为 `plot` 只收数值。

**例 2：T2 需要过界**。`symsum` 建好的 `Ws` 是符号的；而 Newton 循环要算上百次函数值，所以先用 `W = matlabFunction(Ws)` 变成数值句柄，循环里调用 `W(xk)`。

**例 3：T4 的两问各在一个世界**。第 1 问频响：`w = logspace(...)` 是数值数组，直接算 `1j*w`，用 `semilogx` 画。第 2 问：`syms s t` 之后，`laplace`、`ilaplace` 都是符号运算，结果 `v` 用 `fplot` 画。两问之间不需要过界。

---

### 0.9 看懂报错

**解释**：报错是红字，一般有两行：`Error using xxx` 说的是哪个函数报错，`Error in 文件名 (line N)` 说的是你的第几行。**先跳到第 N 行**，再对照下表。橙色的 `Warning` 不会让程序停下来，结果可能不准，但不算出错。

下表的报错原文按较新版本写（tutorial 屏幕上用的是 R2024a），不同版本措辞可能略有差别，认关键词就行。

| 报错关键词 | 最常见的原因 | 怎么改 |
|---|---|---|
| `Incorrect dimensions for matrix multiplication` | 两个向量之间用了 `*`，本意是逐元素相乘 | 改成 `.*`；同理 `^` → `.^`，`/` → `./` |
| `Arrays have incompatible sizes for this operation` | 两个长度不同的向量做 `+ - .*`，比如一个 100 个点、一个 99 个点 | 用 `size()` 检查两边 |
| `Index exceeds the number of array elements` | 下标超出长度，比如只有 100 个元素却取 `x(101)` | 检查循环上限和 `end` |
| `Array indices must be positive integers or logical values` | 下标是 0 或小数，比如 `b(0)`、`x(0.5)` | MATLAB 从 1 开始数；想算"函数在 0.5 处的值"，`x` 必须是函数（句柄），不能是数组 |
| `Unrecognized function or variable 'k'` | 用了没定义过的名字：忘了 `syms k`、拼错了、或者定义它的那一节还没运行 | 补上定义，或先运行前面的节 |
| `Too many input arguments` | 调用时给多了参数。最常见：ode45 的句柄写成 `@(p)`，少了 `t` | 改成 `@(t, p)` |
| `Not enough input arguments` | 调用时给少了参数。最常见：直接按 Run 运行一个**函数文件**（比如 `newton1d.m`），没有传参数 | 在脚本或命令行里调用它，并给齐参数 |
| `... must return a column vector`（ode45） | 右端函数里用了逗号 `[a, b]`，返回的是行向量 | 改成 `[a; b]` |
| `Unable to convert expression containing symbolic variables into double array` | 把还含有符号变量的表达式放进数值数组，或对它用了 `double()` | 先用 `subs` 代入所有符号变量，或者用 `matlabFunction` |

**不报错、结果却是错的**（最难查）：

- 行向量和列向量做运算：`(1:3) + (1:3)'` 不报错，而是悄悄得到一个 3×3 矩阵
- 两个向量之间用了 `/`：`a / b` 不报错，返回**一个数**（MATLAB 把它当成解方程），频响曲线就画不出来
- 忘了 `hold on`：不报错，只是前面画的线没了

---

### ✅ CP 0a（就是那道自测：逐句读懂）

下面几行来自 T3 和 T2。每个问题用一句话回答。

```matlab
dpdt = @(t, p) [ alpha*p(1) - beta*p(1)*p(2);
                 delta*p(1)*p(2) - gamma*p(2) ];
[tSol, ppPop] = ode45(dpdt, tYears, p0);
plot(tSol, ppPop(:,1), 'b-', 'LineWidth', 1.5); hold on
fprintf('x = %.10f, iterations = %d\n', xk, iter);
```

1. `@(t, p)` 是什么？右边没用到 `t`，为什么也要写？
2. 方括号里第一行末尾的 `;` 是什么意思？和行尾的 `;` 一样吗？
3. `p(1)`、`p(2)` 分别是什么？
4. `[tSol, ppPop] =` 是什么写法？当 `tYears = 0:0.05:100` 时，`ppPop` 是几行几列？
5. `ppPop(:,1)` 取出来的是什么？
6. `'b-'` 和 `'LineWidth', 1.5` 分别是什么？
7. 不写 `hold on` 会怎样？
8. `%.10f`、`%d`、`\n` 各是什么？

<details>
<summary>答案</summary>

1. 匿名函数（0.4）：输入 t 和 p，输出右边方括号里的列向量。`ode45` 每次调用都传 `(t, p)` 两个参数，所以句柄必须接收两个，哪怕 Lotka-Volterra 的式子里不含 t。只写 `@(p)` 会报 `Too many input arguments`
2. "换行"：把两个式子竖着拼成 2×1 列向量（0.2）。行尾的 `;` 表示"不打印"，两者无关。写成逗号会得到行向量，ode45 报 `must return a column vector`
3. 当前状态向量的第 1、2 个分量，也就是此刻的兔子数 p₁ 和猞猁数 p₂。顺序和初值 `p0 = [100, 5]` 一致
4. 多输出（0.2）：`ode45` 返回时间和解两样东西，相当于 Python 的 `tSol, ppPop = ode45(...)`。`tYears` 有 2001 个点，所以 `ppPop` 是 **2001×2**：每一行是一个时刻，每一列是一个状态
5. 所有行、第 1 列，即每个时刻的兔子数，也就是整条猎物曲线（0.3）
6. `'b-'` 是线型简写：蓝色、实线。`'LineWidth', 1.5` 是一对 Name-Value 参数：线宽 1.5（0.5）
7. 下一条 `plot`（猞猁）会把兔子这条线擦掉，图上只剩一条线（0.6）
8. `%.10f`：保留 10 位小数的位置，填 `xk`；`%d`：整数的位置，填 `iter`；`\n`：换行（0.7）

</details>

---

### ✅ CP 0b（改错：每一处会怎样？）

下面的代码想完成 T3 和 T4 的一部分，但有 6 处问题。逐行说出：会报什么错（或者不报错，但错在哪里），以及怎么改。

```matlab
clear; clc; close all;
alpha = 0.48; beta = 0.025; delta = 0.68; gamma = 0.02;
dpdt = @(p) [alpha*p(1) - beta*p(1)*p(2), delta*p(1)*p(2) - gamma*p(2)];   % 第 3 行
ppPop = ode45(dpdt, 0:0.05:100, [100 5]);                                  % 第 4 行
w = logspace(0, 4, 1000);
H = (1 + 0.02j*w) / (2 + 0.03j*w);                                         % 第 6 行
plot(ppPop(:,1), ppPop(:,2))                                               % 第 7 行
plot(w, abs(H))                                                            % 第 8 行
fprintf('max gain = %d', max(abs(H)))                                      % 第 9 行
```

<details>
<summary>答案</summary>

| 行 | 问题 | 现象 | 改法 |
|---|---|---|---|
| 3 | 句柄只有一个输入 `@(p)` | `Too many input arguments`（ode45 传了 t 和 p 两个） | `@(t, p)` |
| 3 | 两个式子之间用了逗号 | 改好上一处之后，报 `must return a column vector` | 逗号改成 `;` |
| 4 | 只用一个变量接 `ode45` | 拿到的是结构体，不是解矩阵，第 7 行用它作图会出错 | `[tSol, ppPop] = ode45(...)` |
| 6 | 两个向量之间用了 `/` | **不报错**，但 H 变成一个数，第 8 行画不出频响曲线 | 改成 `./` |
| 7–8 | 第二次 `plot` 之前没开新图 | **不报错**，但相平面图被频响图盖掉 | 第 8 行前加 `figure` |
| 9 | 小数用了 `%d`，也没有 `\n` | **不报错**，但显示成科学计数法，还和下一次输出挤在同一行 | `'max gain = %.4f\n'` |

改好后（max gain 约为 0.6667，也就是 ω → ∞ 时的 2/3）：

```matlab
dpdt = @(t, p) [alpha*p(1) - beta*p(1)*p(2); delta*p(1)*p(2) - gamma*p(2)];
[tSol, ppPop] = ode45(dpdt, 0:0.05:100, [100 5]);
w = logspace(0, 4, 1000);
H = (1 + 0.02j*w) ./ (2 + 0.03j*w);
plot(ppPop(:,1), ppPop(:,2))
figure; semilogx(w, abs(H))            % w 是对数分布的，用 semilogx 更合适（可选）
fprintf('max gain = %.4f\n', max(abs(H)))
```

</details>

---

### ✅ CP 0c（符号还是数值？）

对每一行说出：结果是符号还是数值，会不会报错。

```matlab
syms t
x1 = cos(100*t);                  % (a)
tt = linspace(0, 0.1, 500);       % (b)
plot(tt, x1)                      % (c)
fplot(x1, [0 0.1])                % (d)
v = double(subs(x1, t, 0.01))     % (e)
f = matlabFunction(x1);           % (f)
plot(tt, f(tt))                   % (g)
fprintf('%.4f\n', x1)             % (h)
```

<details>
<summary>答案</summary>

- (a) 符号：t 是符号变量，`x1` 是一个公式
- (b) 数值：500 个数
- (c) **报错**：`plot` 只收数值，而 `x1` 是公式
- (d) 可以：`fplot` 就是用来画符号表达式的
- (e) 数值：先代入 t = 0.01 得到 cos(1)，再转成 double，结果 `0.5403`
- (f) 数值句柄：之后 `f(任意数组)` 都能算
- (g) 可以：`f(tt)` 是 500 个数，做的正是 (c) 想做的事
- (h) **报错**：`fprintf` 打印不了符号公式。想看公式用 `disp(x1)`；想打印数字，就打印 (e) 得到的 `v`

</details>

---

### 📋 抄到 cheatsheet 上（Part 0）

```text
;  行尾=不打印        [a; b] 里的 ; =换行(列向量)     [a, b] 或 [a b] =同一行
%  注释   %% 分节(Run Section)   ... 续行   每题开头 clear; clc; close all;
x(i) 第i个(从1数)   A(i,j) 先行后列   A(:,1) 第1列   A(2,:) 第2行   x(end) 最后一个
1:5 含5   0:0.05:100 → 2001个点   [1 -2]=两个数   [1 - 2]=-1
[a, b] = f(...) 多输出   [~, k] = min(x) 丢掉第1个   ode45 永远写 [t, Y] = ode45(...)
f = @(x) x.^2 - 2        ode45 的句柄: @(t, y) [式1; 式2]  (两个输入，返回列向量)
句柄定义时参数值被"拍照"，改了参数要重新定义句柄
.* ./ .^ 逐元素     * / ^ 矩阵（两个向量之间几乎总要加点）
plot(x, y, 'r--', 'LineWidth', 2, 'DisplayName', 'xxx')
   颜色 b r g k m   线型 - -- :   点 o . x *
figure 新图  hold on 叠加  hold off  subplot(2,1,1) 上半  subplot(2,1,2) 下半
xlabel ylabel title legend('Location','best') grid on   都作用于当前子图
fprintf('a = %.4f, n = %d\n', a, n)  %d整数 %.4f四位小数 %e科学计数 %s字符串 \n换行
title(sprintf('f = %d Hz', f))       字符串里的单引号写两个 ''
syms x → 符号；plot / ode45 / fzero / fprintf 只收数值
符号→数: double(subs(expr, x, 2))   符号→句柄: g = matlabFunction(expr)
画符号: fplot(expr, [a b])          画数值: plot(x, y)
报错: Incorrect dimensions → 加点 | Index exceeds → 下标越界 | indices must be positive → 下标是0或小数
      Unrecognized → 没定义/没syms | Too many input → ode45 句柄少了 t
      must return a column vector → [a, b] 改 [a; b] | Unable to convert ... symbolic → subs 或 matlabFunction
```

---

## Part T — W13 Tutorial 划重点（5 道原题）🎯

> 最后一节 tutorial（11-03）讲的 5 道题。Ex1–4 照抄屏幕上的题目；**Ex5 只拍到代码和输出图，题目和参数是我从代码反推的**。
> 每题标了用到的 KP，卡住就回去补；代码写法看不懂就查 Part 0。数值都用 Python（SymPy / SciPy）核对过；MATLAB 代码按语法写，没有在 MATLAB 里跑过。

| 题 | 内容 | 用到的 KP | 预估 |
|---|---|---|---|
| T1 | 方波的 Fourier 级数（`symsum`） | E4、E2、A8 | 25 min |
| T2 | Weierstrass 函数求零点：无导数 Newton | F2、F4、E4 | 40 min |
| T3 | Lotka-Volterra 捕食者–猎物模型（`ode45` + 相平面） | H3、H4 | 30 min |
| T4 | C1∥R1 – C2∥R2 电路：相量导纳 + 频响 + Laplace 时域响应 | G5、I4、I5 | 45 min |
| T5 | 两节点 RC 电路：节点方程 → 联立 ODE → `dsolve` | G4、G6、I2 | 35 min |

---

### ✅ CP T1（Example 1：Series）

方波可以写成 Fourier 级数：

$$x_{\text{sqr}} = \frac{4}{\pi}\sum_{k=1}^{\infty}\frac{\sin\big(2\pi f t(2k-1)\big)}{2k-1}$$

用 `symsum` 构造并画出方波，取 **f = 2 Hz**，级数截断在 **k = 10**。

**几何直觉**：每一项是一个奇次谐波（频率 f、3f、5f…），振幅按 1/(2k−1) 变小。高次谐波叠上去，把正弦的"圆肩"一点点削平成方波的"直角"。项数越多越方，但跳变处总有约 9% 的过冲，它只会变窄、不会变矮（Gibbs 现象）。

<details>
<summary>答案</summary>

```matlab
clear; clc; close all;
syms k t
f = 2;  K = 10;
xsqr = (4/pi) * symsum(sin(2*pi*f*t*(2*k - 1)) / (2*k - 1), k, 1, K);

figure('Color', 'white');
fplot(xsqr, [0 1], 'LineWidth', 1.5, 'DisplayName', sprintf('Fourier series, k = 1..%d', K)); hold on
tt = linspace(0, 1, 2000);
plot(tt, sign(sin(2*pi*f*tt)), 'k--', 'DisplayName', 'Ideal square wave');
xlabel('t (s)'); ylabel('x_{sqr}(t)');
title(sprintf('Square wave by Fourier series (f = %d Hz, %d terms)', f, K));
legend('Location', 'best'); grid on; hold off

double(subs(xsqr, t, 0.125))     % 自检：应为 0.9682
```

**自检数值**：周期 1/f = 0.5 s；x(0) = x(0.25) = 0；四分之一周期处 x(0.125) = 0.968（理想值 1）；最大值 ≈ **1.180**，出现在跳变附近。K 改成 50，最大值仍是 1.179。

**要点**：

- `k` 必须先 `syms`；上下限是数字时，`symsum` 返回**展开后的 10 项和**，不是闭式
- 符号表达式作图用 `fplot`；要数值就 `subs` + `double`，或 `matlabFunction`（KP E2）
- 理想方波用 `sign(sin(...))` 画，不需要 Signal Processing Toolbox 的 `square`

</details>

---

### ✅ CP T2（Example 2：Newton-Raphson 不可导时）

有些函数求不了导数，比如 $|x|$ 在 0 处不可导，或者处处不可导的 Weierstrass 函数：

$$f(x) = \sum_{n=0}^{\infty} a^n\cos(b^n\pi x),\qquad 0<a<1,\ b \text{ 为正奇数},\ ab > 1 + \tfrac32\pi$$

Newton 法要用导数（Jacobian），这时就失效了。问题是：**没有梯度怎么做？** 写 MATLAB 代码求 Weierstrass 函数的零点（**a = 0.5，b = 11，级数截断在 10**）。

Hint：$f'(x) = \lim_{\Delta x\to 0}\frac{f(x+\Delta x) - f(x)}{\Delta x}$

**思路**：

- 用差商代替导数，$f'(x) \approx \frac{f(x+\Delta x) - f(x)}{\Delta x}$。几何上就是把"切线"换成一条极短的"割线"（KP F4）
- 先用 `symsum` 建函数（和 T1 同一个工具），`matlabFunction` 转成数值句柄
- **先在光滑函数上测代码**，比如 x² − 2，确认代码本身没问题，再用到 Weierstrass 上

<details>
<summary>答案</summary>

```matlab
clear; clc; close all;
syms n x
a = 0.5; b = 11; N = 10;                         % n = 0..10
Ws = symsum(a^n * cos(b^n * pi * x), n, 0, N);
W  = matlabFunction(Ws);                          % 数值句柄 W(x)，接受向量

% 先看一眼函数长什么样
xx = linspace(0, 1, 1e5);
figure('Color', 'white'); plot(xx, W(xx)); grid on
xlabel('x'); ylabel('W(x)'); title('Truncated Weierstrass function, a = 0.5, b = 11');

% --- 差商 Newton ---
x0 = 0.3; dx = 1e-8; tol = 1e-10; maxIter = 100;
xk = x0; converged = false;
for iter = 1:maxIter
    fx   = W(xk);
    dfdx = (W(xk + dx) - fx) / dx;                % 前向差分代替 f'(x)
    step = fx / dfdx;
    xk   = xk - step;
    if abs(step) < tol
        converged = true;
        break
    end
end
fprintf('x = %.10f, W(x) = %.3e, iterations = %d, converged = %d\n', xk, W(xk), iter, converged);
```

**用这份代码会看到什么**（Python 复现同一循环）：

| 截断 | 初值 | 结果 |
|---|---|---|
| N = 2（只取 3 项） | x₀ = 0.3 | 14 次收敛到 **0.2751556621**，W ≈ 4e-15 |
| N = 2 | x₀ = 0.6 | 16 次收敛到 0.5816113850 |
| N = 10（题目要求） | x₀ = 0.3、0.6 | 100 次**不收敛**，W(x) 还在 ±0.4–0.8 |

N = 10 不收敛不是代码写错了。我把初值从 0.1 试到 0.8、Δx 从 1e-1 试到 1e-12，迭代 2000 次都停不下来。

**原因**：n = 10 那一项的周期是 $2/11^{10} \approx 7.7\times10^{-11}$。Δx = 1e-8 时，这条"割线"横跨一百多个周期，斜率和切线毫无关系；Δx 取到 1e-11 以下，$f(x+\Delta x) - f(x)$ 又被浮点舍入误差淹没。所以差商 Newton 对光滑函数很好用，对这种处处剧烈抖动的函数会失败。这正是题目想让你看到的。

**真要找到零点**：用不需要导数的括号法，例如 `fzero(W, [0 1])`（W(0) ≈ 2，W(1) ≈ −2，两端异号），或自己写二分法。用 SciPy 的 Brent 法在 [0, 1] 上测得 x ≈ 0.4999944（MATLAB `fzero` 的具体数字可能略有不同，因为零点非常密）。

**精确零点检验**：x = 1/2。b 是奇数 → bⁿ 都是奇数 → 每一项 $\cos(b^n\pi/2) = 0$，所以 W(0.5) = 0（数值上 ≈ 1.4e-9，是舍入误差）。同理 ±1/2、±3/2…都是零点。拿 `W(0.5)` 检查函数有没有写对。

**考试时**：写出上面的差商 Newton（带 `maxIter` 和收敛判断），用 x² − 2 或小 N 验证，再说明为什么 N = 10 时不收敛、括号法可以兜底。

**题意说明**：题目写"截断在 k = 10"，但求和变量是 n；我按 n = 0…10 处理（置信度中等）。取 n = 0…9，结论一样。

</details>

---

### ✅ CP T3（Example 3：Lotka-Volterra 捕食者–猎物模型）

$$\frac{dp_1}{dt} = \alpha p_1 - \beta p_1 p_2,\qquad \frac{dp_2}{dt} = \delta p_1 p_2 - \gamma p_2$$

p₁ = 雪兔（猎物），p₂ = 猞猁（捕食者）。

- 取 α = 0.48，β = 0.025，δ = 0.68，γ = 0.02
- 在 `tYears = 0:0.05:100` 的所有时刻用 `ode45` 求解，初值 `p0 = [100, 5]`
- 结果存进 2 列矩阵 `ppPop`：第 1 列猎物，第 2 列捕食者
- 画两个种群随时间的变化；再画两个种群互相对着的图（相平面）

**直觉**：兔子多 → 猞猁有得吃、变多 → 兔子被吃少 → 猞猁饿死变少 → 兔子又变多……相平面上就是绕着平衡点转圈。

<details>
<summary>答案</summary>

```matlab
clear; clc; close all;
alpha = 0.48; beta = 0.025; delta = 0.68; gamma = 0.02;    % 照题目给的数字
dpdt = @(t, p) [ alpha*p(1) - beta*p(1)*p(2);
                 delta*p(1)*p(2) - gamma*p(2) ];          % 必须返回列向量
tYears = 0:0.05:100;
p0 = [100, 5];
[tSol, ppPop] = ode45(dpdt, tYears, p0);   % ppPop：2001×2，第 1 列猎物，第 2 列捕食者

figure('Color', 'white');
subplot(2,1,1);
plot(tSol, ppPop(:,1), 'b-', 'LineWidth', 1.5); hold on
plot(tSol, ppPop(:,2), 'r-', 'LineWidth', 1.5); hold off
xlabel('t (years)'); ylabel('Population');
title('Lotka-Volterra: populations vs time');
legend('Snow hares p_1', 'Canadian lynxes p_2', 'Location', 'best'); grid on

subplot(2,1,2);
plot(ppPop(:,1), ppPop(:,2), 'k-', 'LineWidth', 1.5); hold on
plot(p0(1), p0(2), 'go', 'MarkerFaceColor', 'g'); hold off
xlabel('Hares p_1'); ylabel('Lynxes p_2');
title('Phase plane: predator vs prey');
legend('Trajectory', 'Initial state', 'Location', 'best'); grid on
```

**要点**：

- 传 `tYears` 向量（而不是 `[0 100]`），输出就正好在这些时刻，`size(ppPop)` = `[2001 2]`
- 右端两行之间用分号 → 列向量；初值写成行向量 `[100, 5]` 没关系
- "Plot against each other" = **相平面图**：横轴猎物，纵轴捕食者，时间不出现在图上。闭合曲线 = 周期解
- `beta`、`gamma` 会暂时遮住 MATLAB 的内置函数 `beta()`、`gamma()`。脚本里能用，只是别在同一个工作区里再调用这两个函数

**⚠️ 参数可能印反了（置信度中等）**

- **照题目**（δ = 0.68，γ = 0.02）：捕食者一年内暴涨到约 **2840**，猎物几乎灭绝（数值上还会出现 ≈ −1e-6 的负数），之后捕食者以每年 2% 缓慢下降，t = 100 时约 386。100 年里**看不到周期**。平衡点 p₁* = γ/δ ≈ 0.03 只兔子，不合常理
- **δ、γ 互换**（δ = 0.02，γ = 0.68）：平衡点 (γ/δ, α/β) = **(34, 19.2)**，出现经典的周期振荡：周期约 14 年，猎物约 4–127，捕食者约 1–85，相平面是闭合环。这才像野兔–猞猁的真实数据
- 考试照题目给的数字写，**代码完全一样**，只是参数不同。结果看起来不对劲时，在答案里用一句话说明（比如平衡点不合理），比自己偷偷改参数安全

</details>

---

### ✅ CP T4（Example 4：电路分析）

电路：v_s → **C1 ∥ R1**（串联支路）→ 输出节点 v → **C2 ∥ R2** 接地。C1 = 0.02 F，C2 = 0.01 F，R1 = R2 = 1 Ω。

1. 在相量域求电路导纳，画电压增益 |v/v_s| 和相位随输入频率 ω 变化的曲线
2. 用 Laplace 变换求 v_s(t) = cos(ωt)、ω = 100 时的 v(t)，并在 t ∈ [0, 0.5] 上作图

> 和 W11 lecture 的例子、CP I4 是**同一个电路**，参数换成了 F 级电容，并加了 Laplace 部分。

<details>
<summary>答案</summary>

**推导**

- 两个支路的导纳：$Y_1 = \frac{1}{R_1} + j\omega C_1$，$Y_2 = \frac{1}{R_2} + j\omega C_2$
- 电源看进去的**总导纳**：两支路串联 → 阻抗相加 → $Y = \frac{1}{1/Y_1 + 1/Y_2} = \frac{Y_1Y_2}{Y_1 + Y_2}$
- 增益：节点 KCL $(v_s - v)Y_1 = vY_2$ → $H = \frac{v}{v_s} = \frac{Y_1}{Y_1 + Y_2} = \frac{1 + j0.02\omega}{2 + j0.03\omega}$

**第 1 问：相量域**

```matlab
clear; clc; close all;
C1 = 0.02; C2 = 0.01; R1 = 1; R2 = 1;
w  = logspace(0, 4, 1000);                 % 1 到 1e4 rad/s
Y1 = 1/R1 + 1j*w*C1;                       % C1 || R1
Y2 = 1/R2 + 1j*w*C2;                       % C2 || R2
Y  = Y1.*Y2 ./ (Y1 + Y2);                  % total admittance seen by vs
H  = Y1 ./ (Y1 + Y2);                      % voltage gain v/vs

Y100 = (1/R1 + 1j*100*C1)*(1/R2 + 1j*100*C2) / (1/R1 + 1j*100*C1 + 1/R2 + 1j*100*C2);
fprintf('Y(j100) = %.4f + j%.4f S\n', real(Y100), imag(Y100));

figure('Color', 'white');
subplot(2,1,1); semilogx(w, abs(H), 'LineWidth', 1.5); grid on
ylabel('|v / v_s|'); title('Voltage gain of the C1||R1 - C2||R2 network');
subplot(2,1,2); semilogx(w, rad2deg(angle(H)), 'LineWidth', 1.5); grid on
xlabel('\omega (rad/s)'); ylabel('Phase (deg)');
```

自检：

| | 值 | 物理意义 |
|---|---|---|
| ω → 0 | \|H\| = **1/2**，相位 0 | 电容开路，两个电阻分压 |
| ω → ∞ | \|H\| = **2/3**，相位 0 | 电容"短路"主导，按电容分压 C1/(C1+C2) |
| ω = 100 | \|H\| = **0.620**，∠H = **+7.1°**；Y = 0.538 + j0.692 S | 第 2 问的稳态要和它一致 |
| 相位最大 | ≈ +8.2°，在 ω ≈ 57.7 rad/s | 零点 50 和极点 66.7 的几何平均 |

零点 ω = 1/(R1C1) = 50，极点 ω = (1/R1 + 1/R2)/(C1 + C2) = 66.7。

**第 2 问：Laplace**

```matlab
syms s t
Y1s = 1/R1 + s*C1;  Y2s = 1/R2 + s*C2;
G   = simplify(Y1s / (Y1s + Y2s))          % (2*s + 100)/(3*s + 200)
Vs  = laplace(cos(100*t), t, s);           % s/(s^2 + 10000)
v   = simplify(ilaplace(G*Vs, s, t))

figure('Color', 'white');
fplot(v, [0 0.5], 'LineWidth', 1.5); grid on
xlabel('t (s)'); ylabel('v(t) (V)');
title('v(t) for v_s = cos(100t), via Laplace transform');
```

结果（MATLAB 的显示形式可能不同，代入 t = 0 应得 2/3）：

$$v(t) = \underbrace{\tfrac{8}{13}\cos(100t) - \tfrac{1}{13}\sin(100t)}_{\text{稳态}} + \underbrace{\tfrac{2}{39}e^{-200t/3}}_{\text{暂态}}$$

- 稳态部分 = 0.620 cos(100t + 7.1°)，和第 1 问的 \|H(j100)\|、∠H(j100) **完全一致** → 两问可以互相检验
- 暂态时间常数 τ = 3/200 = 15 ms，到 t ≈ 0.075 s 基本消失，所以 [0, 0.5] 上主要看到稳态
- v(0⁺) = 8/13 + 2/39 = **2/3**：上电瞬间电容像短路，按电容分压

</details>

---

### ✅ CP T5（Example 5：两节点 RC 电路，联立 ODE）

> 题目没拍到。下面是从屏幕上的代码和输出反推的。

**电路**：v_s —R1— 节点 1 —R2— 节点 2 —R3— 地；C1 从节点 1 接地，C2 从节点 2 接地。零初始电压，t = 0 接上 v_s = 10 V。

**参数**：屏幕上看不到 R、C 的值。根据输出里的 $e^{-t}$、$e^{-3t}$ 项和曲线终值（6.67、3.33），反推为 R1 = R2 = R3 = 1 Ω，C1 = C2 = 1 F（置信度约 85%）。

**任务**：列两个节点的 KCL 方程，用 `dsolve` 求 v₁(t)、v₂(t)，画在一张图上。

**列方程的套路**（KP G6）：每个节点"流出"的电流之和 = 0，即电容电流 $C\frac{dv}{dt}$ 加上通往每个邻居的电阻电流 $\frac{v_{\text{本节点}} - v_{\text{邻居}}}{R}$。

<details>
<summary>答案</summary>

```matlab
clear; clc; close all;
syms v1(t) v2(t)
R1 = 1; R2 = 1; R3 = 1; C1 = 1; C2 = 1; vs = 10;

eq1 = C1*diff(v1,t) + (1/R1)*(v1 - vs) + (1/R2)*(v1 - v2) == 0;   % 节点 1
eq2 = C2*diff(v2,t) + (1/R2)*(v2 - v1) + (1/R3)*v2      == 0;     % 节点 2
cond1 = v1(0) == 0;
cond2 = v2(0) == 0;

S = dsolve([eq1, eq2], [cond1, cond2]);     % 结构体，字段 S.v1、S.v2
v1Sol = simplify(S.v1)
v2Sol = simplify(S.v2)

figure('Color', 'white');
fplot(v1Sol, [0 10], 'LineWidth', 1.5); hold on
fplot(v2Sol, [0 10], 'LineWidth', 1.5);
xlabel('t (s)'); ylabel('Voltage (V)');
title('Two-node RC circuit, zero initial conditions');
legend('v_1(t)', 'v_2(t)', 'Location', 'southeast'); grid on; hold off
```

tutorial 写的是 `[v1, v2] = dsolve(eq1, eq2, cond1, cond2);`，也能跑，但会把符号函数 `v1(t)`、`v2(t)` 覆盖成解。用结构体 `S` 不会混淆。

**结果**：

$$v_1(t) = \tfrac{20}{3} - 5e^{-t} - \tfrac53 e^{-3t},\qquad v_2(t) = \tfrac{10}{3} - 5e^{-t} + \tfrac53 e^{-3t}$$

**三个检查**：

1. **t → ∞**：电容开路，三个电阻串联分压 → v₁ = 10·2/3 = 6.67，v₂ = 10·1/3 = 3.33（和屏幕上的曲线一致）
2. **指数 −1、−3** = 系数矩阵 $A = \begin{bmatrix}-2&1\\1&-2\end{bmatrix}$ 的特征值 → sink node，稳定（KP I2）
3. **v₂ 开头是平的**：t = 0 时 v₁ = v₂ = 0，节点 2 没有电流流入，v₂′(0) = 0；v₂ 要等 v₁ 先充上去

**加问：用 ode45 验证**（KP H3、J5）

```matlab
A = [-(1/R1 + 1/R2)/C1,  1/(R2*C1);
      1/(R2*C2),        -(1/R2 + 1/R3)/C2];
B = [vs/(R1*C1); 0];
[tn, xn] = ode45(@(t, x) A*x + B, [0 10], [0; 0]);
eig(A)          % -3, -1
```

</details>

---

## Part A — MATLAB 基础（W1–2）

> 单独考的概率不高，但**每道题都建立在这些上面**。维度错误是最常见的丢分点。答案代码里的写法看不懂，先看 Part 0。

### KP A1 数组构造与索引 ★★★

**直觉**：MATLAB 里一切都是矩阵，标量是 1×1。行向量 vs 列向量搞混 = 一半的报错来源。

```matlab
d = [5, 7, 2];                 % 行向量 1x3（逗号或空格分隔）
e = [5; 7; 2];                 % 列向量 3x1（分号换行）
x = 0:0.5:2;                   % 起点:步长:终点
X = linspace(0, 3*pi, 100)';   % 100 个点，' 转成列向量（Week 6 quiz 原题要求）
d(1), d(end), d(2:end)         % 1-based 索引，end = 最后一个
A = [1 2 3; 4 5 6];
A(2,3), A(:,1), A(1,:)         % (行,列)；: 表示整行/整列
[nr, nc] = size(A); numel(A); length(d)
zeros(2), ones(2,4), eye(3), rand(2,1), randn(100,1)
```

**坑**：

- `'` 是**共轭**转置（复数会取共轭），纯转置用 `.'`
- `linspace` 默认生成**行**向量

#### ✅ CP A1

每问一行代码：
(a) 生成 0 到 3π 共 100 个点的**列**向量 `X`
(b) 从 `X` 的第 10 个元素开始，每隔一个取一个
(c) 把 `A = magic(4)` 的第 2 列全部改成 0
(d) `size(X(10:2:end))` 是多少？

<details>
<summary>答案</summary>

```matlab
X = linspace(0, 3*pi, 100)';   % (a)
X(10:2:end)                    % (b)
A = magic(4); A(:,2) = 0;      % (c)
```

(d) 下标 10,12,…,100 共 46 个 → `[46 1]`（列向量切片后仍是列向量）

</details>

---

### KP A2 逐元素运算 vs 矩阵运算 ★★★

| 逐元素 | 矩阵 |
|---|---|
| `.*` `./` `.^` | `*` `/` `^` |
| 两个数组尺寸必须相同（或可广播） | 内维必须匹配 |

- 点积：`a*b'`（1×3 乘 3×1 → 标量）
- 外积：`b'*a`（3×1 乘 1×3 → 3×3 矩阵）

#### ✅ CP A2

`a = [2 4 6]; b = [1 2 2];` 求 `a.*b`、`a./b`、`a*b'`、`size(b'*a)`。
再解释：`X = linspace(0,1,5)'; X^2` 为什么报错？

<details>
<summary>答案</summary>

- `a.*b = [2 8 12]`，`a./b = [2 2 3]`，`a*b' = 22`，`size(b'*a) = [3 3]`
- `X^2` 等于 `X*X`，要求方阵；`X` 是 5×1 → 报错。要逐元素平方用 `X.^2`。**Week 6 quiz 里 `(S/100)*X.^2` 必须带点。**

</details>

---

### KP A3 复数 ★★

```matlab
c = 10 + 2j;            % i 或 j 都行；循环变量常用 i，复数建议写 1j 避免冲突
abs(c); angle(c);       % 模、辐角（弧度）
real(c); imag(c); conj(c);
rad2deg(angle(c))
exp(-1j*pi/2)           % = -1j（显示 0.0000 - 1.0000i，实部是 6e-17 浮点误差）
```

#### ✅ CP A3

`c = 10 + 2j`，写出 `abs`、`angle`（弧度和角度）、`real`、`imag`、`conj`、`c'`。

<details>
<summary>答案</summary>

`abs = √104 = 10.198`，`angle = atan(0.2) = 0.1974 rad = 11.31°`，`real = 10`，`imag = 2`，`conj = 10 − 2j`，`c' = 10 − 2j`（标量的共轭转置就是共轭）

</details>

---

### KP A4 多项式 ★★

系数向量按**降幂**排列：$y = x^4 - 2x^2 + 3$ → `P = [1 0 -2 0 3]`（缺的次数补 0）

```matlab
polyval(P, 2)     % 在 x=2 处求值
r = roots(P);     % 根
poly(r)           % 由根还原多项式
conv(P, Q)        % 多项式相乘
```

#### ✅ CP A4

`P = x⁴ − 2x² + 3`，`Q = (x+1)²`。求 `polyval(P,2)`、`conv(P,Q)`。不用 `polyval`，怎么快速检验 `conv` 结果是否正确？

<details>
<summary>答案</summary>

```matlab
P = [1 0 -2 0 3]; Q = [1 2 1];
polyval(P,2)      % 11
conv(P,Q)         % [1 2 -1 -4 1 6 3]
```

检验：x=1 时 P(1)=2，Q(1)=4，乘积应为 8；而 `conv` 结果所有系数之和 = 1+2−1−4+1+6+3 = 8 ✓（系数和 = 多项式在 x=1 的值）

</details>

---

### KP A5 脚本 / 函数 / 匿名函数 / 局部函数 ★★★

```matlab
% --- 函数文件 fxn1.m（文件名必须与函数名一致）---
function v = fxn1(a, omega, delta, T)
t = linspace(0, T, T/10+1);   % t 是局部变量，函数结束就消失
v = a*sin(omega*t + delta);
end

% --- 匿名函数（存在工作区，像变量一样）---
cos50 = @(t) cos(2*pi*50*t);
f = @(t) exp(-t).*sin(2*pi*t);   % 要支持向量输入 → 用 .*

% --- function functions：参数是函数句柄 ---
fplot(f, [0 3]); fzero(f, 0.4); integral(f, 0, 1);

% --- 脚本里的局部函数：必须放在脚本最后 ---
```

**坑**：匿名函数里忘了用 `.*` / `.^` → 传向量进去时报错或结果错误。

#### ✅ CP A5

写匿名函数 $f(t) = e^{-t}\sin(2\pi t)$，在 [0, 3] 上画图，并用 `fzero` 求 t = 0.1 之后的第一个零点。

<details>
<summary>答案</summary>

```matlab
f = @(t) exp(-t).*sin(2*pi*t);
fplot(f, [0 3]); grid on
t1 = fzero(f, [0.3 0.7])     % 0.5
```

零点在 $\sin(2\pi t) = 0$ → t = 0.5（括号 [0.3, 0.7] 两端异号）

</details>

---

### KP A6 逻辑运算与流程控制 ★★★

```matlab
% 关系运算逐元素，结果是 logical（0/1）
Y(Y < 0) = 0;               % 逻辑索引：把负数置 0
nnz(Y > 1)                  % 统计个数
any(v > 5); all(v > 0);
strcmp(s1, s2)              % 字符串比较（不能用 ==）
% & | 逐元素；&& || 短路（只用于标量，if/while 条件里用）

if x > 0
    ...
elseif x == 0
    ...
else
    ...
end

for k = 1:10, ..., end      % 已知次数
while err > tol, ..., end   % 未知次数（循环体内必须改变条件）
break / continue / return
switch mode
    case 'poly', ...
    case {'sin','cos'}, ...
    otherwise, ...
end
```

**原则**：能向量化就别写循环（slides 原话：循环比向量运算慢得多）。

#### ✅ CP A6a（W2 的应用例子：Taylor 级数）

用 `while` 循环计算 $e^1 = \sum_{k=0}^{\infty} \frac{1}{k!}$，直到**新加的项** < 1e-8 停止。输出和、加了多少项，并与 `exp(1)` 比较。

<details>
<summary>答案</summary>

```matlab
x = 1; s = 0; term = 1; k = 0;
while abs(term) > 1e-8
    s = s + term;
    k = k + 1;
    term = x^k / factorial(k);
end
fprintf('sum = %.10f, terms = %d, exp(1) = %.10f\n', s, k, exp(1));
```

结果：sum = 2.7182818262，加了 12 项（k = 0…11），误差约 2.3e-9。

</details>

#### ✅ CP A6b

给定向量 `Y`：(a) 一行统计负数个数；(b) 一行把负数置 0；(c) 为什么 (a) 必须在 (b) 之前做？

<details>
<summary>答案</summary>

(a) `nnz(Y < 0)`（或 `sum(Y < 0)`）　(b) `Y(Y < 0) = 0;`　(c) (b) 之后已经没有负数了，计数会变成 0。

</details>

---

### KP A7 cell 与 struct ★

```matlab
C = {'Archie', 1:5, magic(3)};   % {} 构造
C(2)        % 返回 1x1 cell（还包着盒子）
C{2}        % 返回内容本身 [1 2 3 4 5]
C{3}(2,1)   % 先取内容再索引
cellfun(@max, {1:10, [2;4;6]})                       % [10 6]
cellfun(@max, {1:10, [2;4;6], []}, 'UniformOutput', false)  % 含空数组要这样
s.name = 'Joe'; s.vec = 1:4;      % struct：点号访问字段
```

#### ✅ CP A7

`C = {1:10, [2;4;6], []};` 直接 `cellfun(@max, C)` 会怎样？怎么改？

<details>
<summary>答案</summary>

`max([])` 返回空数组，不是标量，默认 `UniformOutput = true` 要求每个输出是标量 → 报错。改成 `cellfun(@max, C, 'UniformOutput', false)`，返回 cell `{10, 6, []}`。

</details>

---

### KP A8 专业作图 ★★★（Week 6 quiz 里单独占 20 分）

```matlab
figure('Color','white');
scatter(X, Y, 30, 'filled', 'DisplayName', 'Data'); hold on
plot(X, Yfit1, 'r-',  'LineWidth', 2, 'DisplayName', 'Polynomial fit (n=5)');
plot(X, Yfit2, 'g--', 'LineWidth', 2, 'DisplayName', 'Sinusoidal fit (n=5)');
xlabel('X'); ylabel('Y');
title('Least-squares fits via QR decomposition');
legend('Location', 'best'); grid on; hold off
```

其他常用：`subplot(2,1,1)`、`semilogx`、`loglog`、`fplot`（画函数句柄或 sym 表达式；slides 里的 `ezplot` 是旧版写法，现在推荐 `fplot`）

**评分清单**：☐ 数据点用 scatter　☐ 每条拟合曲线　☐ title　☐ xlabel　☐ ylabel　☐ legend 能区分三者　☐ `hold on` / `hold off`

#### ✅ CP A8

下面的作图代码会丢哪些分？

```matlab
plot(X, Y)
plot(X, Yp)
plot(X, Ys)
title('fit')
```

<details>
<summary>答案</summary>

1. 没有 `hold on` → 只剩最后一条曲线
2. 原始数据用折线而不是 scatter
3. 没有 xlabel / ylabel
4. 没有 legend
5. 标题不清楚（应说明是什么拟合、用什么方法）

</details>

---

## Part B — 线性代数：LU / QR / 最小二乘（W3 + W6 quiz）

> **Week 6 quiz 原题在这一部分，优先级很高。**

### KP B1 三角矩阵与前代 / 回代 ★★

**直觉**：下三角系统像多米诺骨牌——第一行只有一个未知数，解出来代入第二行，再代入第三行……不需要求逆。

- 下三角 $Lx = b$：**前代**（forward substitution），从第 1 行往下
- 上三角 $Ux = b$：**回代**（backward substitution），从最后一行往上
- 三角矩阵的行列式 = 对角元素乘积

$$x_i = \frac{b_i - \sum_{j<i} l_{ij}x_j}{l_{ii}}$$

#### ✅ CP B1

不用 `\` 和 `inv`，写函数 `x = forwardSub(L, b)`，用下面的数据测试，并求 `det(L)`：

$$L = \begin{bmatrix}2&0&0\\1&3&0\\4&-1&5\end{bmatrix},\quad b = \begin{bmatrix}2\\7\\13\end{bmatrix}$$

<details>
<summary>答案</summary>

```matlab
function x = forwardSub(L, b)
n = length(b);
x = zeros(n,1);
for i = 1:n
    x(i) = (b(i) - L(i,1:i-1)*x(1:i-1)) / L(i,i);
end
end
```

手算：x₁ = 2/2 = 1；x₂ = (7 − 1)/3 = 2；x₃ = (13 − 4·1 + 1·2)/5 = 2.2
→ `x = [1; 2; 2.2]`，`det(L) = 2·3·5 = 30`

</details>

---

### KP B2 LU 分解 ★★★

$$PA = LU$$

- L 下三角（MATLAB 令对角全为 1），U 上三角，P 置换矩阵（把绝对值最大的元素换到主元位置，避免除以接近 0 的数 = **pivoting**）
- 本质就是高斯消元

**解 $Ax = b$ 的四步**：

1. $LUx = Pb$
2. 令 $z = Ux$ → $Lz = Pb$，**前代**解 z
3. $Ux = z$，**回代**解 x

```matlab
[L, U, P] = lu(A);
z = L \ (P*b);     % 前代
x = U \ z;         % 回代
% 等价于 x = A\b（MATLAB 对方阵内部就是这么做的）
```

**为什么不用 `inv(A)*b`**：更慢、数值误差更大。LU 分解一次 $O(n^3)$，之后每个新的 b 只需 $O(n^2)$。

#### ✅ CP B2

$A = \begin{bmatrix}1&2&3\\2&3&4\\3&5&6\end{bmatrix}$，$b = [14;\,20;\,31]$。
(a) 用 LU 求 x 并与 `A\b` 比较
(b) P 的作用是什么？
(c) 由 LU 结果求 `det(A)`

<details>
<summary>答案</summary>

```matlab
A = [1 2 3; 2 3 4; 3 5 6]; b = [14; 20; 31];
[L, U, P] = lu(A);
x = U \ (L \ (P*b))     % [1; 2; 3]
A \ b                   % 相同
```

(a) x = [1; 2; 3]（验算：第一行 1+4+9=14 ✓）
(b) 第一列最大的是 3（第 3 行），P 把第 3 行换到最上面做主元
(c) $\det(A) = \det(P)^{-1}\prod \mathrm{diag}(U) = 3 \times 0.3333 \times 1 \div (+1) = 1$。P 是 3-轮换，det(P) = +1。直接展开：1·(18−20) − 2·(12−12) + 3·(10−9) = 1 ✓

</details>

---

### KP B3 QR 分解 ★★★

$$A = QR$$

- **Q 正交**：$Q^TQ = I$，即列向量两两正交且长度为 1。几何上 Q 是旋转/反射，**不改变向量长度**
- **R 上三角**
- 对 N×K 的"高瘦"矩阵（N ≫ K）用**经济型**：

| 写法 | Q 大小 | R 大小 |
|---|---|---|
| `[Q,R] = qr(A)` | N×N | N×K（下面 N−K 行全 0） |
| `[Q,R] = qr(A,0)` 或 `qr(A,'econ')` | N×K | K×K |

#### ✅ CP B3

A 是 100×6 矩阵。写出完整版和经济版 QR 中 Q、R 的大小，并写一行代码验证 Q 的列正交。

<details>
<summary>答案</summary>

完整版：Q 100×100，R 100×6；经济版：Q 100×6，R 6×6。
验证：`norm(Q'*Q - eye(6))` 应约为 1e-15。

</details>

---

### KP B4 最小二乘与曲线拟合 ★★★（Week 6 quiz 核心）

**模型**：用 K 个基函数的线性组合拟合 N 个数据点

$$F(x_i) = \sum_{k=1}^{K} w_k f_k(x_i) \approx y_i,\quad i = 1,\dots,N$$

**设计矩阵**（design matrix）：$M_{ik} = f_k(x_i)$，**每一列 = 一个基函数在所有数据点上的取值**。
N > K 时方程比未知数多（超定，overdetermined），一般没有精确解 → 求

$$\min_w \lVert Mw - y \rVert^2$$

**几何直觉**（这是理解一切的关键）：

- $Mw$ 无论 w 取什么，都落在 M 的**列空间**里（$\mathbb{R}^N$ 中一个 K 维平面）
- y 通常不在这个平面上
- 最近的点 = y 在平面上的**正交投影** → 残差 $y - Mw$ 垂直于每一列
- 写成式子就是**正规方程**：$M^T(y - Mw) = 0 \Rightarrow M^TMw = M^Ty$

**QR 解法**（quiz 指定的方法）：

$$\lVert Mw - y\rVert = \lVert QRw - y \rVert \;\xrightarrow{\;Q^T \text{ 不改变长度}\;}\; \text{最小化 } \lVert Rw - Q^Ty \rVert \;\Rightarrow\; Rw = Q^Ty$$

R 是上三角 → 回代即可：

```matlab
[Q, R] = qr(A, 0);        % 经济型
w = R \ (Q' * y);
```

**为什么不直接用正规方程 `inv(A'*A)*A'*y`**：条件数会**平方**。实测 Week 6 quiz 的设计矩阵：`cond(A) ≈ 3.5e5`，`cond(A'*A) ≈ 1.2e11`，精度直接少掉 5–6 位。

**构造设计矩阵的写法**：

```matlab
X = X(:);                                  % 确保是列向量
n = 5;
A_poly = X.^(0:n);                         % [1, X, X.^2, ..., X.^5]，隐式扩展
A_sin  = [ones(size(X)), sin(X*(1:n))];    % [1, sin(X), sin(2X), ..., sin(5X)]
A_gen  = [ones(size(X)), exp(-X), log(X+1)];   % 任意基函数
% 循环写法（最稳，旧版 MATLAB 也能跑）：
A_poly = zeros(length(X), n+1);
for i = 0:n
    A_poly(:, i+1) = X.^i;
end
```

**坑**：

- `polyfit(x, y, n)` 返回的系数是**降幂**（$x^n$ 在前），和 `A = [1, X, X², …]` 求出的 w **顺序相反**
- X 不是列向量时，`X.^(0:n)` 会得到错误形状
- 题目指定用 QR，就别写 `A\Y`（虽然结果一样，可能丢方法分）

#### ✅ CP B4a（手算）

用直线 $y = w_0 + w_1x$ 拟合 (0,1)、(1,3)、(2,4)、(3,4)，用正规方程手算 w。

<details>
<summary>答案</summary>

$$M = \begin{bmatrix}1&0\\1&1\\1&2\\1&3\end{bmatrix},\quad M^TM = \begin{bmatrix}4&6\\6&14\end{bmatrix},\quad M^Ty = \begin{bmatrix}12\\23\end{bmatrix}$$

$\det = 56 - 36 = 20$，$(M^TM)^{-1} = \frac{1}{20}\begin{bmatrix}14&-6\\-6&4\end{bmatrix}$

$w_0 = (14·12 − 6·23)/20 = 30/20 = 1.5$，$w_1 = (−6·12 + 4·23)/20 = 20/20 = 1$
→ **y = 1.5 + x**

MATLAB 验证：`[Q,R] = qr(M,0); w = R\(Q'*y)` → `[1.5; 1]`

</details>

#### ✅ CP B4b（Week 6 quiz 原题）

**验收标准**：不看答案写出来；然后把正弦基换成别的（例如 `[1, cos(X), cos(2X), …]` 或 `[1, exp(-X), X.*sin(X)]`），数据和参数也改掉，仍能自己搭设计矩阵、用 QR 求解、作图。会迁移比背熟这一份脚本重要。

参数：D = 生日日期，M = 生日月份，S = 学号后四位之和（为 0 则取 1）。

1. X：0 到 3π 的 100 点**列**向量；$Y = \frac{D}{5}\cos(0.5X) + \frac{M}{10}\sin(2X) - \frac{S}{100}X^2 + \frac{S}{20}\,\text{randn}$
2. 多项式模型 n=5：构造 A_poly，用 QR 求 w_poly，带标签显示
3. 正弦模型 n=5（$w_0 + \sum w_k\sin(kX)$）：构造 A_sin，用 QR 求 w_sin，带标签显示
4. 一张图：数据 scatter + 两条拟合曲线，完整 title/label/legend
5. **（加问）** 用 RMSE 或 R² 判断哪个模型更好，并解释原因

<details>
<summary>答案</summary>

```matlab
clear; clc; close all;

%% Parameters
D = 14; M = 3; S = 16;          % 换成自己的
if D == 0, D = 1; end
if M == 0, M = 1; end
if S == 0, S = 1; end

%% Data
X = linspace(0, 3*pi, 100)';
Y = (D/5)*cos(0.5*X) + (M/10)*sin(2*X) - (S/100)*X.^2 + (S/20)*randn(size(X));

%% Part A: polynomial, n = 5
n = 5;
A_poly = zeros(length(X), n+1);
for i = 0:n
    A_poly(:, i+1) = X.^i;
end
[Qp, Rp] = qr(A_poly, 0);
w_poly = Rp \ (Qp' * Y);
disp('Polynomial weights w_poly (w0 ... w5):'); disp(w_poly);

%% Part B: sinusoidal, n = 5
A_sin = zeros(length(X), n+1);
A_sin(:, 1) = 1;
for i = 1:n
    A_sin(:, i+1) = sin(i*X);
end
[Qs, Rs] = qr(A_sin, 0);
w_sin = Rs \ (Qs' * Y);
disp('Sinusoidal weights w_sin (w0 ... w5):'); disp(w_sin);

%% Part C: plot
Yp = A_poly * w_poly;
Ys = A_sin  * w_sin;
figure('Color', 'white');
scatter(X, Y, 30, 'filled', 'DisplayName', 'Generated data'); hold on
plot(X, Yp, 'r-',  'LineWidth', 2, 'DisplayName', 'Polynomial fit (n=5)');
plot(X, Ys, 'g--', 'LineWidth', 2, 'DisplayName', 'Sinusoidal fit (n=5)');
xlabel('X'); ylabel('Y');
title('System modelling: least squares via QR decomposition');
legend('Location', 'best'); grid on; hold off

%% Extra: which model is better?
rmse = @(e) sqrt(mean(e.^2));
R2   = @(yhat) 1 - sum((Y - yhat).^2) / sum((Y - mean(Y)).^2);
fprintf('Polynomial: RMSE = %.3f, R^2 = %.3f\n', rmse(Y - Yp), R2(Yp));
fprintf('Sinusoidal: RMSE = %.3f, R^2 = %.3f\n', rmse(Y - Ys), R2(Ys));
```

用 D=14, M=3, S=16 跑三次（噪声不同）：多项式 R² ≈ 0.98，RMSE ≈ 0.7–0.85；正弦 R² ≈ 0.07–0.09，RMSE ≈ 5.5。**多项式明显更好**。

原因：数据主体是 $-\frac{S}{100}X^2$ 的抛物线趋势加上 $\cos(0.5X)$。正弦基 $\sin(kX)$ 的周期都 ≤ 2π，而且不含任何 cos 项，表示不了缓慢的抛物线下降；5 次多项式在 [0, 3π] 上能很好地近似 $X^2$ 和 $\cos(0.5X)$，只有幅度小的 $\frac{M}{10}\sin(2X)$ 拟合不到。

</details>

#### ✅ CP B4c

`w_p = polyfit(X, Y, 5)` 和 CP B4b 的 `w_poly` 是什么关系？

<details>
<summary>答案</summary>

`polyfit` 返回降幂 $[w_5, w_4, \dots, w_0]$，所以 `flip(w_p)'` ≈ `w_poly`（数值上可能差一点点，因为算法不同）。

</details>

---

### KP B5 特征值与 Markov 链 ★★（W4 slides 缺，但 W5 lab 和 W11 都要用）

```matlab
[V, D] = eig(A);     % A*V = V*D，D 对角线是特征值，V 的列是特征向量
```

**Markov 链稳态分布**：行和为 1 的转移矩阵 P，稳态 π 满足 $\pi P = \pi$
→ 转置后 $P^T\pi^T = \pi^T$ → π 是 $P^T$ 特征值为 1 对应的特征向量，再归一化使和为 1。

#### ✅ CP B5

$P = \begin{bmatrix}0.9&0.1\\0.5&0.5\end{bmatrix}$，求稳态分布（手算 + 代码）。

<details>
<summary>答案</summary>

手算：$\pi_1 = 0.9\pi_1 + 0.5\pi_2 \Rightarrow 0.1\pi_1 = 0.5\pi_2 \Rightarrow \pi_1 = 5\pi_2$，又 $\pi_1 + \pi_2 = 1$ → **π = [5/6, 1/6] ≈ [0.833, 0.167]**

```matlab
P = [0.9 0.1; 0.5 0.5];
[V, D] = eig(P');
[~, k] = min(abs(diag(D) - 1));   % 找特征值 = 1 的那一列
pi_s = V(:,k) / sum(V(:,k));      % 归一化（也顺便消掉可能的负号）
disp(pi_s')
```

</details>

---

### KP B6 Hermitian / 正定 / Cholesky ★

- **Hermitian**：$A = A^*$（共轭转置等于自己），即复数版的对称矩阵
- **正定**：$z^*Az > 0$ 对所有非零 z 成立 ⇔ Hermitian 且特征值全为正
- `R = chol(A)` 给出 $A = R^TR$，只对正定矩阵成立（不是正定会报错，可以拿来当判定方法）

#### ✅ CP B6

$A = \begin{bmatrix}2&2+i\\2-i&3\end{bmatrix}$ 是 Hermitian 吗？正定吗？

<details>
<summary>答案</summary>

`isequal(A, A')` = true → Hermitian。迹 = 5，行列式 = 6 − (2+i)(2−i) = 6 − 5 = 1 > 0，两个特征值同号且和为正 → 都为正（0.209、4.791）→ 正定，`chol(A)` 能成功。

</details>

---

## Part C — 概率模型（W5）

> slides 原话：不用背公式，**重点是知道什么场景用什么分布、参数是什么意思**。

### KP C1 pmf / pdf / cdf ★★

- **cdf**：$F(x) = P(X \le x)$，离散连续都适用
- **离散 → pmf**：$P(X = x)$，所有取值求和 = 1
- **连续 → pdf**：$f(x)$，$F(x) = \int_{-\infty}^{x} f(y)\,dy$；单点概率 = 0，概率 = 曲线下面积

#### ✅ CP C1

连续随机变量 X 的 $P(X = 2)$ 是多少？用 F 表示 $P(1 < X \le 3)$。

<details>
<summary>答案</summary>

$P(X=2) = 0$（单点没有面积）；$P(1 < X \le 3) = F(3) - F(1)$

</details>

---

### KP C2 分布对象与常用函数 ★★★

```matlab
pd = makedist('Normal', 'mu', 1, 'sigma', 3);
pd.mean; pd.var; pd.std; pd.median
pd.pdf(x); pd.cdf(x); pd.icdf(p)     % 也可写 pdf(pd,x), cdf(pd,x)
pd.random(1, 5)                      % 或 random(pd, 1, 5)
% 函数式写法：normpdf/normcdf, binopdf/binocdf, poisspdf/poisscdf, expcdf ...
rng(42);          % 固定随机种子 → 结果可复现
rand(3,1)         % [0,1] 均匀分布——所有其他随机数都是由它变换来的
unidrnd(N, m, n)  % 1..N 的离散均匀整数
```

#### ✅ CP C2

`pd = makedist('Normal','mu',1,'sigma',3)`：求 `pd.var`、$P(X \le 4)$、$P(|X - 1| \le 3)$。

<details>
<summary>答案</summary>

`var = 9`；$P(X \le 4)$ = `pd.cdf(4)` = 0.8413（= 均值以上 1σ）；$P(|X-1| \le 3)$ = `pd.cdf(4) - pd.cdf(-2)` = 0.6827（±1σ 的经典 68%）

</details>

---

### KP C3 工程常用分布 ★★★（选对分布 + 参数别写错）

| 场景 | 分布 | MATLAB | 参数坑 |
|---|---|---|---|
| 单次成功/失败 | Bernoulli(p) | Binomial 取 N=1 | — |
| n 次试验成功 k 次 | Binomial(n, p) | `makedist('Binomial','N',n,'p',p)` | — |
| 多于两种结果（掷骰子） | Multinomial | `mnrnd` | ★ |
| **到达间隔时间** / 恒定失效率的寿命 | Exponential(λ) | `makedist('Exponential','mu',1/lambda)` | ⚠️ `mu` 是**均值** = 1/λ，不是速率 |
| **固定时间内的到达个数** | Poisson | `makedist('Poisson','lambda',lambda*T)` | ⚠️ λ 要乘区间长度 T |
| 失效率随时间变化（老化 / 早期失效） | Weibull(a, b) | `makedist('Weibull','a',a,'b',b)` | a 尺度，b 形状 |
| 无线信道衰落 / 二维高斯的模 | Rayleigh(σ) | `makedist('Rayleigh','b',sigma)` | = Weibull(a = √2σ, b = 2) |
| 随机排列 / 随机抽样 | — | `randperm(n,k)`、`randsample(pop,k,true)` | 默认**无放回** |

**直觉**：

- Poisson 和 Exponential 描述**同一个过程**：Exponential 看"两次到达之间隔多久"，Poisson 看"一段时间里来了几个"
- Weibull 形状参数 b：**b < 1** 失效率下降（早期缺陷），**b = 1** 恒定（退化为 Exponential，均值 a），**b > 1** 失效率上升（老化、磨损）。也用于风速、电网峰值负荷建模

#### ✅ CP C3a（Binomial）

有偏硬币 p = 0.7，抛 6 次。求恰好 4 次正面、至少 4 次正面的概率。

<details>
<summary>答案</summary>

```matlab
pd = makedist('Binomial', 'N', 6, 'p', 0.7);
pd.pdf(4)          % 0.3241
1 - pd.cdf(3)      % 0.7443   （至少 4 次 = 1 − 至多 3 次）
```

</details>

#### ✅ CP C3b（到达过程 → 服务器缓冲区大小）

任务以 λ = 2 个/秒 到达服务器。
(i) 相邻两个任务间隔超过 1 秒的概率
(ii) 3 秒内到达超过 10 个任务的概率
(iii) 缓冲区至少多大，才能保证 3 秒内到达数不超过容量的概率 ≥ 99%？

<details>
<summary>答案</summary>

```matlab
lambda = 2;
pe = makedist('Exponential', 'mu', 1/lambda);
1 - pe.cdf(1)              % (i)  e^{-2} = 0.1353
pp = makedist('Poisson', 'lambda', lambda*3);   % 3 秒 → λT = 6
1 - pp.cdf(10)             % (ii) 0.0426
pp.icdf(0.99)              % (iii) 12
```

(iii) 验算：P(K ≤ 11) = 0.9799 < 0.99，P(K ≤ 12) = 0.9912 ≥ 0.99 → **12**

</details>

#### ✅ CP C3c（Weibull）

(a) `makedist('Weibull','a',2,'b',2)` 的均值？(b) 给配电变压器的老化失效建模，b 应该大于还是小于 1？(c) Weibull(a=0.5, b=1) 等于哪个 Exponential？

<details>
<summary>答案</summary>

(a) 1.7725（= aΓ(1+1/b) = 2Γ(1.5) = √π）　(b) b > 1（失效率随时间上升）　(c) Exponential，均值 mu = 0.5，即 λ = 2

</details>

---

## Part D — 统计与机器学习（W6）

### KP D1 描述统计 ★★

```matlab
mean(y); var(y); std(y); median(y); mode(y);
prctile(y, [25 50 75])     % 四分位数
boxplot(y); histogram(y);
```

**坑**：`var` 默认除以 **N−1**（样本方差）；`var(y,1)` 除以 N。

#### ✅ CP D1

`y = [2 4 4 4 5 5 7 9]`，求 mean、median、mode、`var(y)`、`var(y,1)`。

<details>
<summary>答案</summary>

mean = 5，median = 4.5，mode = 4。偏差 −3,−1,−1,−1,0,0,2,4，平方和 = 32 → `var(y)` = 32/7 = 4.571，`var(y,1)` = 32/8 = 4（std = 2）

</details>

---

### KP D2 拟合分布 fitdist / histfit ★★

```matlab
pd = fitdist(data(:), 'Normal');    % 'Rayleigh', 'Weibull', 'Exponential', ...
histfit(data, nbins, 'weibull');    % 直方图 + 拟合曲线叠在一起
```

#### ✅ CP D2（W6 lecture 例子）

从 N(0, 4²) 生成两行各 1000 个样本，计算 `speed = sqrt(Y1.^2 + Y2.^2)`，用 `fitdist` 拟合 Rayleigh。参数 B 应该接近多少？为什么？

<details>
<summary>答案</summary>

```matlab
N = 1000; sigma = 4;
pd0 = makedist('Normal', 'mu', 0, 'sigma', sigma);
Y = pd0.random(2, N);                 % 2 行 N 列（拆成两行写最稳妥）
speed = sqrt(Y(1,:).^2 + Y(2,:).^2);
pd = fitdist(speed', 'Rayleigh')      % B ≈ 4
histfit(speed, 30, 'rayleigh');
```

B ≈ σ = 4。两个独立零均值、标准差为 σ 的高斯分量，合成向量的模服从 Rayleigh(σ)（这也是无线衰落用 Rayleigh 的原因：I/Q 两路高斯）。

</details>

---

### KP D3 线性回归 = 最小二乘 ★★★

- "线性"指对**参数 β 线性**，不是对 x 线性 → $y = \beta_0 + \beta_1x + \beta_2x^2$ 也是线性回归
- OLS 估计：$\hat\beta = (X^TX)^{-1}X^Ty$，MATLAB 里直接 `X\y`（内部用 QR）
- 残差 $e_i = y_i - \hat y_i$，SSE = $\sum e_i^2$
- 和 Part B4 是**同一件事**，只是统计学的叫法

#### ✅ CP D3

下面哪些能用线性回归（`X\y`）直接拟合？不能的怎么办？
(a) $y = \beta_0 + \beta_1e^x + \beta_2\sin x$　(b) $y = \beta_0e^{\beta_1x}$

<details>
<summary>答案</summary>

(a) 能：对 β 线性，设计矩阵 `[ones(size(x)), exp(x), sin(x)]`
(b) 不能直接拟合：β₁ 在指数里，对参数非线性。取对数 $\ln y = \ln\beta_0 + \beta_1x$ 后对 $(\ln\beta_0, \beta_1)$ 线性，可以用 `[ones(size(x)), x] \ log(y)` 拟合（要求 y > 0）

</details>

### KP D4 拟合优度 R² ★★★

$$R^2 = 1 - \frac{\text{SSE}}{\text{SST}} = 1 - \frac{\sum (y_i - \hat y_i)^2}{\sum (y_i - \bar y)^2}$$

- 含义：输出的变化中有 R²×100% 能被输入解释
- R² = 1 完美拟合；R² = 0 和"只用均值"一样差
- slides：真实世界里 R² = 0.4–0.6 已经很好

#### ✅ CP D4

求 CP B4a 那条直线（y = 1.5 + x）的 SSE、SST、R²。

<details>
<summary>答案</summary>

ŷ = [1.5, 2.5, 3.5, 4.5]，残差 = [−0.5, 0.5, 0.5, −0.5] → SSE = 1
ȳ = 3，SST = 4 + 0 + 1 + 1 = 6
**R² = 1 − 1/6 = 0.833**

</details>

---

### KP D5 多项式阶数与过拟合 ★★

阶数越高，训练数据上 SSE 越小，但外推/插值会剧烈振荡（过拟合）。

#### ✅ CP D5（找 bug：lecture 原代码）

```matlab
y = rand(10,1); X = (1:10)';
M = ones(10,1); b = {};
for n = 0:5
    M = [X.^n, M];
    b(n) = { M \ y };
end
```

找出两个 bug 并改正。

<details>
<summary>答案</summary>

1. `n = 0` 时 `b(0)` → MATLAB 索引从 1 开始，报错
2. M 一开始已经是全 1 列，`n = 0` 时又拼上 `X.^0`（也是全 1）→ 两列相同，矩阵秩亏，之后每个模型都多一个冗余列，`polyval` 的系数个数也不对

```matlab
M = ones(10,1); b = {};
b{1} = M \ y;                 % 0 阶
for n = 1:5
    M = [X.^n, M];            % 降幂排列，和 polyval 一致
    b{n+1} = M \ y;
end
xx = linspace(1, 10, 200);
figure; plot(X, y, 'o', 'DisplayName', 'data'); hold on
for n = 0:5
    plot(xx, polyval(b{n+1}, xx), 'DisplayName', sprintf('degree %d', n));
end
legend; hold off
```

</details>

---

### KP D6 分类与 logistic 回归 ★

- 回归：输出是数值；分类：输出是类别
- 机器学习术语：观测 = **instance**，自变量 = **feature**，类别 = **class**
- Logistic 回归（名字叫回归，其实是**分类器**）：

$$p = \frac{1}{1 + e^{-(\beta_0 + \beta_1 x)}} \in (0, 1)$$

  p > 0.5 判为类 1。β 由极大似然估计（交给 MATLAB：`fitglm(X, y, 'Distribution', 'binomial')`），不考推导。

#### ✅ CP D6

β₀ = −4，β₁ = 2。x = 3 时属于类 1 的概率？决策边界在哪？

<details>
<summary>答案</summary>

$p = 1/(1 + e^{-2}) = 0.881$ → 判为类 1。决策边界：$\beta_0 + \beta_1x = 0$ → **x = 2**（此时 p = 0.5）

</details>

---

## Part E — 符号计算（W7）

> 后面 W8–W12 全在用。核心六个函数：`syms` `subs` `solve` `diff` `int` `matlabFunction`。W13 tutorial 的 Ex1、Ex2 还用了 `symsum`。

### KP E1 创建符号对象 ★★★

```matlab
syms x y z real            % 一次建多个；加 real 假设化简更干净
a = sym('alpha');          % 变量名 a，显示为 alpha
syms f(x)                  % 符号函数
f(x) = x^2 + 1;  f(2)      % 5
eq = str2sym('E = k*Q/r^2');   % 字符串 → 方程
sym(1/3)                   % 精确的 1/3，而不是 0.3333
```

#### ✅ CP E1

分别在 `syms x`、`syms x real`、`syms x positive` 三种声明下执行 `simplify(sqrt(x^2))`，结果各是什么？为什么？

<details>
<summary>答案</summary>

`syms x` → `(x^2)^(1/2)`（x 可能是复数，不能化简）；`syms x real` → `abs(x)`；`syms x positive` → `x`。
假设越强，化简越彻底——这就是 slides 里习惯写 `syms t real` 的原因。

</details>

### KP E2 化简与代换 ★★★ 🎯

```matlab
expand(f); factor(f); collect(f, x); simplify(f);
subs(expr, [r, theta], [2, pi/3])     % 多个变量同时代入
double(ans); vpa(ans, 6)              % 转成数值
g = matlabFunction(expr);             % sym → 数值函数句柄（fzero / ode45 / 快速作图要用）
```

🎯 W13 Ex2（CP T2）：`symsum` 建好 Weierstrass 函数后，用 `matlabFunction` 转成数值句柄才能放进 Newton 循环。

#### ✅ CP E2a

化简 $f = \frac{(x+1)(x+2)(x+3)}{x^2+4x+4}$，分别给出 `simplify` 和 `factor` 的结果。

<details>
<summary>答案</summary>

分母 $= (x+2)^2$，约掉一个 (x+2)：
`simplify(f)` → $\frac{x^2 + 4x + 3}{x + 2}$；`factor(f)` → $\frac{(x+1)(x+3)}{x+2}$
（slides 上印的 `(2 + 4*x + 3)` 少了个平方）

</details>

#### ✅ CP E2b

$X = r\cos\theta$，$Y = r\sin\theta$，代入 r = 2、θ = π/3，求精确值和数值。

<details>
<summary>答案</summary>

```matlab
syms r theta real
X = r*cos(theta); Y = r*sin(theta);
x1 = subs(X, [r, theta], [2, pi/3])    % 1
y1 = subs(Y, [r, theta], [2, pi/3])    % 3^(1/2)
double(y1)                             % 1.7321
```

</details>

---

### KP E3 solve ★★★

```matlab
syms x a b c
solve(x^2 - 9 == 0, x)             % [-3; 3]
solve(a*x^2 + b*x + c == 0, x)     % 求根公式
solve(a*x^2 + b*x + c == 0, b)     % 指定对 b 求解
% 方程组
syms x y
S = solve([x + y == 3, x^2 + y^2 == 5], [x, y]);
S.x, S.y
[sx, sy] = solve([x + y == 3, x^2 + y^2 == 5], [x, y]);
vpasolve(eqn, x, x0)               % 求不出解析解时的数值解
```

**坑**：不写 `== 0` 时默认令表达式 = 0；不指定变量时默认解 x（或字母表上离 x 最近的那个）。

#### ✅ CP E3

解方程组 x + y = 3，x² + y² = 5。

<details>
<summary>答案</summary>

代入 y = 3 − x：x² + (3−x)² = 5 → 2x² − 6x + 4 = 0 → x = 1 或 2
→ **(x, y) = (1, 2) 或 (2, 1)**，代码见上面模板，`S.x = [1; 2]`，`S.y = [2; 1]`

</details>

---

### KP E4 级数 symsum ★★★ 🎯（v1 为 ★★）

```matlab
syms x k
symsum((-1)^(k-1) * x^(2*(k-1)) / factorial(2*(k-1)), k, 1, 5)
taylor(cos(x), x, 'Order', 10)     % 展开到 x^9
```

- 语法：`symsum(f, k, a, b)`，也可以写 `symsum(f, k, [a b])`。求和变量 `k` 必须先 `syms`
- 上下限是数字 → 返回**展开后的有限和**；上限是 `Inf` → MATLAB 尝试求闭式
- 结果是符号表达式：作图用 `fplot`，求数值用 `subs` + `double`，进循环用 `matlabFunction`
- 🎯 W13 Ex1（方波 Fourier 级数，CP T1）和 Ex2（Weierstrass 函数，CP T2）都用 `symsum` 建函数

#### ✅ CP E4

用 `symsum` 写出 cos x 的 Maclaurin 级数前 5 项，并用 `taylor` 验证。

<details>
<summary>答案</summary>

$1 - \frac{x^2}{2} + \frac{x^4}{24} - \frac{x^6}{720} + \frac{x^8}{40320}$，`taylor(cos(x), x, 'Order', 10)` 给出相同结果（Order 10 表示截断到 x⁹ 项，cos 只有偶次项，所以最高 x⁸）。

</details>

---

### KP E5 微积分 ★★★

```matlab
diff(f, x); diff(f, x, 2)             % 一阶、二阶导
int(f, x)                             % 不定积分（不加常数）
int(f, x, a, b); int(f, x, 0, Inf)    % 定积分、反常积分
jacobian([f1, f2, f3], [x, y, z])     % 雅可比矩阵：第 i 行 = f_i 对各变量的偏导
det(J); gradient(f, [x y]); hessian(f, [x y]);
int(int(f, y, 0, x), x, 0, 1)         % 二重积分：先内后外
```

#### ✅ CP E5a

求 $F = [xyz,\; y^2,\; x+z]$ 对 (x, y, z) 的 Jacobian 及其行列式。

<details>
<summary>答案</summary>

$$J = \begin{bmatrix}yz & xz & xy\\0 & 2y & 0\\1 & 0 & 1\end{bmatrix},\quad \det J = 2y^2(z - x)$$

（按第二行展开：$2y \cdot (yz \cdot 1 - xy \cdot 1) = 2y^2(z-x)$；MATLAB `factor(det(J))` 显示为 `-2*y^2*(x - z)`）

</details>

#### ✅ CP E5b

$\int_0^1\int_0^x xy\,dy\,dx$

<details>
<summary>答案</summary>

内层：$\int_0^x xy\,dy = x^3/2$；外层：$\int_0^1 x^3/2\,dx = 1/8$
`int(int(x*y, y, 0, x), x, 0, 1)` → `1/8`

</details>

#### ✅ CP E5c（W7 lecture 例子：圆周运动）

点以恒定速率 V = 2 沿半径 R = 3 的圆**顺时针**运动，从 (3, 0) 出发。写出 r(t)，用 `diff` 求 v(t)、a(t)，并验证 |v| = 2、|a| = V²/R。

<details>
<summary>答案</summary>

```matlab
syms t real
R = sym(3); V = sym(2);
b = -V/R;                         % 角速度 V/R，负号 = 顺时针
r = R*[cos(b*t), sin(b*t)];
v = diff(r, t);
a = diff(v, t);                   % 或 diff(r, t, 2)
simplify(sqrt(sum(v.^2)))         % 2
simplify(sqrt(sum(a.^2)))         % 4/3 = V^2/R（向心加速度）
int(int(a, t), t)                 % 回到 r（不定积分不加常数，这里刚好吻合）
```

</details>

---

## Part F — 非线性方程（W8）

### KP F1 roots 与 fzero（括号法）★★★

- 多项式：`roots([1 2 1])` → [−1, −1]
- 一般函数一维求根：`fzero(f, [a b])`，**要求 f(a)·f(b) < 0**（介值定理：连续函数两端异号，中间必有零点）
- `fzero(f, x0)`：只给一个初值，它自己去找括号
- 符号表达式先 `matlabFunction` 转成句柄
- 选项：`opts = optimset('Display','iter','TolX',1e-10); fzero(f, x0, opts)`

**坑**：括号法只看**符号变化**——如果中间是一个**间断点**（比如 tan 在 π/2），它也会把间断点当成"零点"返回。**先画图再求根。**

#### ✅ CP F1a

(a) 用 `fzero` 求 $1/\tan x$ 在 [0.5, 2.5] 内的零点（符号表达式 → `matlabFunction`）
(b) `fzero(@tan, [1 2])` 返回什么？这是真的零点吗？

<details>
<summary>答案</summary>

```matlab
syms x
y = 1/tan(x);
fplot(y, [0.5 2.5]); grid on
fzero(matlabFunction(y), [0.5 2.5])    % 1.5708 = π/2，cot(π/2) = 0 ✓
[xz, fv] = fzero(@tan, [1 2])          % xz = 1.5708, fv ≈ -1.2e15
```

(b) tan(1) > 0、tan(2) < 0，两端异号，但 π/2 是 tan 的**极点**不是零点。返回的 fval 是巨大的数（Octave 实测 −1.2e15 并提示收敛到奇点）——检查 fval 就能发现。

</details>

#### ✅ CP F1b（lab 风格应用：二极管电路，拓展）

Vs = 5 V 串电阻 R = 1 kΩ 接二极管，$I_D = I_s(e^{V_D/V_T} - 1)$，$I_s = 10^{-12}$ A，$V_T = 25$ mV。由 KVL 求 V_D 和电流。

<details>
<summary>答案</summary>

KVL：$\frac{V_s - V_D}{R} = I_s(e^{V_D/V_T} - 1)$

```matlab
Vs = 5; R = 1e3; Is = 1e-12; VT = 0.025;
f = @(Vd) Is*(exp(Vd/VT) - 1) - (Vs - Vd)/R;
Vd = fzero(f, [0 1])        % 0.5554 V
I  = (Vs - Vd)/R            % 4.445 mA
```

</details>

---

### KP F2 Newton-Raphson（一维）★★★ 🎯

$$x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}$$

**几何**：在当前点作切线，切线和 x 轴的交点就是下一个猜测值。

- 收敛很快（二次收敛：接近根时有效数字每步大约翻倍）
- 需要导数；初值要离根近；$f'(x_n) \approx 0$ 时会飞出去
- 停止条件：$|\Delta x| < \text{tol}$ 或达到最大迭代次数
- 🎯 W13 Ex2（CP T2）：导数求不出来时，用差商代替，见 KP F4

#### ✅ CP F2a（手算）

用 Newton 法求 √2（f = x² − 2），x₀ = 3，手算前 3 步。

<details>
<summary>答案</summary>

$x_{n+1} = x_n - \frac{x_n^2 - 2}{2x_n}$

- x₁ = 3 − 7/6 = **1.833333**
- x₂ = 1.833333 − 1.361111/3.666667 = **1.462121**
- x₃ = **1.414998**
- x₄ = 1.414214（已有 6 位正确），x₅ = 1.414213562373112（≈ 15 位）

注意 x₃ → x₄ → x₅ 有效数字从 3 位 → 6 位 → 15 位，这就是二次收敛。

</details>

#### ✅ CP F2b（代码）

写通用函数 `[x, k] = newton1d(f, df, x0, tol, maxIter)`，用 √2 和 CP F1b 的二极管方程（x₀ = 0.7）测试。如果 √2 的 x₀ = 0 会怎样？

<details>
<summary>答案</summary>

```matlab
function [x, k] = newton1d(f, df, x0, tol, maxIter)
x = x0;
for k = 1:maxIter
    dx = f(x) / df(x);
    x = x - dx;
    if abs(dx) < tol
        return
    end
end
warning('Newton did not converge in %d iterations', maxIter);
end
```

```matlab
[r, k] = newton1d(@(x) x.^2-2, @(x) 2*x, 3, 1e-12, 50)      % 1.41421356..., 6 次左右
Is = 1e-12; VT = 0.025; R = 1e3; Vs = 5;
f  = @(Vd) Is*(exp(Vd/VT)-1) - (Vs-Vd)/R;
df = @(Vd) Is/VT*exp(Vd/VT) + 1/R;
[Vd, k] = newton1d(f, df, 0.7, 1e-12, 50)                    % 0.5554, 约 11 次
```

x₀ = 0：f'(0) = 0 → 除以 0 → Inf/NaN。

</details>

---

### KP F3 Newton-Raphson（多维）★★★

n 个方程 n 个未知数：

$$\mathbf{x}_{n+1} = \mathbf{x}_n - J(\mathbf{x}_n)^{-1}\mathbf{f}(\mathbf{x}_n)$$

J 的 (i, k) 元 = $\partial f_i / \partial x_k$。**MATLAB 写 `x = x - J\F`**（不要写 `F/J`，维度不对）。

**套路**：符号求 Jacobian → `matlabFunction` 转句柄 → 数值迭代

#### ✅ CP F3

用 Newton 法解 x² + y² = 5、xy = 2，初值 (0.5, 2.5)。
如果初值是 (1, 1) 会怎样？

<details>
<summary>答案</summary>

```matlab
syms x y
F = [x^2 + y^2 - 5; x*y - 2];
J = jacobian(F, [x, y]);              % [2x 2y; y x]
Ff = matlabFunction(F, 'Vars', {[x; y]});
Jf = matlabFunction(J, 'Vars', {[x; y]});

v = [0.5; 2.5];
for k = 1:50
    dv = Jf(v) \ Ff(v);
    v = v - dv;
    if norm(dv) < 1e-10, break; end
end
fprintf('x = %.6f, y = %.6f after %d iterations\n', v(1), v(2), k);   % (1, 2)，6 次
```

初值 (1, 1)：$J = \begin{bmatrix}2&2\\1&1\end{bmatrix}$，行列式 = 0 → 奇异，第一步就失败。这就是 slides 说的"只有初值靠近解时才好用"。

</details>

---

### KP F4 无导数求根：差商 Newton / 割线法 ★★★ 🎯（v1 为 ★；割线法本身 ★★，梯度下降 ★）

**差商 Newton**（W13 Ex2 的 hint，CP T2）：没有解析导数时，用差商代替

$$f'(x) \approx \frac{f(x+\Delta x) - f(x)}{\Delta x}$$

几何上就是把"切线"换成一条极短的"割线"。

- **Δx 的取舍**：太大 → 割线斜率不等于切线斜率；太小 → $f(x+\Delta x) - f(x)$ 被浮点舍入误差淹没。光滑函数一般取 1e-6 到 1e-8
- 函数本身剧烈抖动（Weierstrass 那种）时，任何 Δx 都不行 → 改用括号法（`fzero` 给区间、二分法）
- 一定要有 `maxIter` 和收敛标志，不收敛时要能看出来

**割线法**：用前两次迭代点的连线斜率代替导数（每步只多算一次 f）

$$x_{n+1} = x_n - f(x_n)\frac{x_n - x_{n-1}}{f(x_n) - f(x_{n-1})}$$

**优化**：最小化非线性函数时沿梯度下坡（一阶方法）；非凸会陷入局部极小、可能振荡（★）

#### ✅ CP F4

f = x² − 2，x₀ = 3，x₁ = 2，割线法一步。

<details>
<summary>答案</summary>

f(3) = 7，f(2) = 2 → x₂ = 2 − 2·(2−3)/(2−7) = 2 − 0.4 = **1.6**

</details>

#### ✅ CP F4b（差商 Newton 测试）

把 CP F2b 的 `df` 换成前向差分（Δx = 1e-8），解 x² − 2 = 0，x₀ = 3。迭代次数和解析导数版相比如何？

<details>
<summary>答案</summary>

```matlab
f = @(x) x.^2 - 2; dx = 1e-8;
x = 3;
for k = 1:50
    step = f(x) / ((f(x + dx) - f(x)) / dx);
    x = x - step;
    if abs(step) < 1e-10, break; end
end
fprintf('x = %.15f, iterations = %d\n', x, k);   % 1.414213562373095, 6 次
```

和解析导数版一样是 6 次左右：光滑函数上，差商几乎等于真导数。这一步也是 CP T2 的"先测代码"。

</details>

---

## Part G — ODE 解析解 + 电路 + 相量（W9）

### KP G1 一阶线性常系数 ODE ★★★

$$\frac{dy}{dt} = ay + q(t)$$

- 齐次解 $y_h = Ce^{at}$（C 由初值定）
- 特解 $y_p$ 取决于源 q(t)：常数、阶跃、冲激、指数、正弦
- 完整解 $y = y_h + y_p$
- **a < 0 → 指数衰减（稳定）**，时间常数 τ = −1/a

两个最基本的例子：$y' = y \Rightarrow e^t$（Taylor 级数）；$y' = y^2 \Rightarrow \frac{1}{1-t}$（几何级数，非线性，t = 1 时爆掉）

#### ✅ CP G1

手解 dy/dt = −2y + 4，y(0) = 0，并给出时间常数。

<details>
<summary>答案</summary>

稳态（令 y' = 0）：y_p = 2；齐次：Ce^{−2t}；y(0) = 0 → C = −2
**y = 2(1 − e^{−2t})**，τ = 0.5

</details>

---

### KP G2 dsolve ★★★ 🎯

```matlab
syms y(t) a
eqn = diff(y, t) == a*y;
dsolve(eqn)                          % C1*exp(a*t)

cond = y(0) == 5;
ySol(t) = dsolve(diff(y,t) == 6*y, cond)    % 5*exp(6*t)

% 二阶：两个初值，导数初值要先定义 Dy
Dy = diff(y, t);
eqn2 = diff(y, t, 2) + 3*diff(y, t) + 2*y == 0;
conds = [y(0) == 1, Dy(0) == 0];
ySol2(t) = dsolve(eqn2, conds)

% 联立（W13 Ex5）：方程和初值各放进一个数组，返回结构体
syms u(t) w(t)
S = dsolve([diff(u,t) == -u + w, diff(w,t) == u - w], [u(0) == 1, w(0) == 0]);
S.u, S.w
```

（旧写法 `dsolve('Dy = y')` 已淘汰，看到认识即可）

🎯 联立方程的完整电路例子见 KP G6 和 CP T5。

#### ✅ CP G2a

y'' + 3y' + 2y = 0，y(0) = 1，y'(0) = 0，手解并用 `dsolve` 验证。

<details>
<summary>答案</summary>

特征方程 r² + 3r + 2 = 0 → r = −1, −2；y = Ae^{−t} + Be^{−2t}
y(0) = A + B = 1；y'(0) = −A − 2B = 0 → A = 2，B = −1
**y = 2e^{−t} − e^{−2t}**

</details>

#### ✅ CP G2b

`dsolve(diff(y,t,2) == a*y)` 返回 $C_1e^{\sqrt a t} + C_2e^{-\sqrt a t}$。a = 4 和 a = −4 时解分别是什么样子？

<details>
<summary>答案</summary>

a = 4：r = ±2，实根 → $e^{2t}$、$e^{-2t}$（一个增长一个衰减）
a = −4：r = ±2j，复根 → $e^{\pm 2jt}$ = cos 2t ± j sin 2t → **振荡**

</details>

---

### KP G3 特征方程与 Euler 公式 ★★

- 实根 r → $e^{rt}$
- 复根 α ± jω → $e^{\alpha t}(A\cos\omega t + B\sin\omega t)$
- $e^{j\theta} = \cos\theta + j\sin\theta$（把 $e^{it}$ 的 Taylor 级数按实部虚部分开即得）

#### ✅ CP G3

y'' + 2y' + 5y = 0 的通解形式？是否衰减？

<details>
<summary>答案</summary>

r² + 2r + 5 = 0 → r = −1 ± 2j → **y = e^{−t}(A cos 2t + B sin 2t)**，衰减振荡（实部 −1 < 0）

</details>

---

### KP G4 元件关系与 Kirchhoff 定律 ★★★ 🎯

| | 电压 | 电流 | 连续量 |
|---|---|---|---|
| R | v = iR | i = v/R | — |
| L | $v = L\frac{di}{dt}$ | $i = \frac1L\int v\,dt + i(t_0)$ | **电流**连续 |
| C | $v = \frac1C\int i\,dt + v(t_0)$ | $i = C\frac{dv}{dt}$ | **电压**连续 |

- KVL：回路电压代数和 = 0；KCL：节点电流和 = 0
- **电路阶数** = 不可合并的储能元件个数（串联 L、并联 C 先合并）= ODE 阶数
- 🎯 W13 Ex4、Ex5 都要先对节点列 KCL

#### ✅ CP G4（W9 RL 例子）

Vs = 10 V，R = 5 Ω，L = 0.1 H 串联，t = 0 合开关，i(0) = 0。写 ODE，求 i(t)、v_R(t)、τ，并写 `dsolve` 代码。

<details>
<summary>答案</summary>

KVL：$L\frac{di}{dt} + Ri = V_s$ → $i(t) = \frac{V_s}{R}(1 - e^{-Rt/L}) = 2(1 - e^{-50t})$ A，$v_R = 10(1 - e^{-50t})$ V，τ = L/R = 20 ms

```matlab
syms i(t)
Vs = 10; R = 5; L = 0.1;
iSol(t) = dsolve(L*diff(i,t) + R*i == Vs, i(0) == 0)   % 2 - 2*exp(-50*t)
vR(t) = R*iSol;
fplot(iSol, [0 0.1]); xlabel('t (s)'); ylabel('i (A)'); title('RL step response'); grid on
```

</details>

---

### KP G5 相量与复阻抗 ★★★ 🎯

- $v(t) = V_m\cos(\omega t + \phi)$ ↔ 相量 $V = V_m\angle\phi = V_me^{j\phi}$（**默认用 cos 形式**）
- 回到时域：$v(t) = |V|\cos(\omega t + \angle V)$
- $Z = V/I$（单位 Ω，是复数但不是相量）；导纳 $Y = 1/Z$

| | 阻抗 Z | 导纳 Y |
|---|---|---|
| R | R | 1/R |
| L | jωL | −j/(ωL) |
| C | 1/(jωC) = −j/(ωC) | jωC |

- **串联加 Z，并联加 Y**；分压 $V_{out} = V_{in}\frac{Z_2}{Z_1 + Z_2}$
- 增益 = 输出幅度 / 输入幅度 = 相量模之比
- 相量法只给**稳态**（= ODE 的特解）；暂态（齐次解）要用 Laplace
- 🎯 W13 Ex4（CP T4）问"电路导纳"：先求两个支路的导纳 Y₁、Y₂；两支路串联 → 总导纳 $Y = \frac{Y_1Y_2}{Y_1+Y_2}$

#### ✅ CP G5a（串联 RLC，相量计算）

$v_s = 10\cos(1000t)$ V，R = 10 Ω，L = 10 mH，C = 100 μF 串联。求电流相量 I 和电容电压 $v_C(t)$。

<details>
<summary>答案</summary>

$Z_L = j1000 \cdot 0.01 = j10$，$Z_C = 1/(j1000 \cdot 10^{-4}) = -j10$
$Z = 10 + j10 - j10 = 10$ Ω（**恰好谐振**：ω₀ = 1/√(LC) = 1000）
$I = 10/10 = 1\angle 0°$ A
$V_C = I \cdot Z_C = -j10 = 10\angle{-90°}$ → **$v_C(t) = 10\cos(1000t - 90°) = 10\sin(1000t)$ V**

```matlab
w = 1000; R = 10; L = 10e-3; C = 100e-6;
Z = R + 1j*w*L + 1/(1j*w*C);
I = 10 / Z;
Vc = I / (1j*w*C);
fprintf('|I| = %.3f A, angle = %.1f deg\n', abs(I), rad2deg(angle(I)));
fprintf('|Vc| = %.3f V, angle = %.1f deg\n', abs(Vc), rad2deg(angle(Vc)));
```

</details>

#### ✅ CP G5b（W9 LC 例子）

vs 经串联 L 接到 C，输出 v_C。推导 $H(\omega) = V_C/V_s$，并用 L = 10 mH、C = 100 μF 画 |H| 随 ω 变化的曲线。

<details>
<summary>答案</summary>

$H = \frac{Z_C}{Z_L + Z_C} = \frac{1/(j\omega C)}{j\omega L + 1/(j\omega C)} = \frac{1}{1 - \omega^2 LC}$，ω₀ = 1/√(LC) = 1000 rad/s 处分母为 0 → 理想 LC 无损耗，谐振峰无穷大

```matlab
L = 10e-3; C = 100e-6;
H = @(w) 1 ./ (1 - w.^2*L*C);
w = linspace(0, 3000, 2000);
plot(w, abs(H(w))); ylim([0 20]); grid on
xlabel('\omega (rad/s)'); ylabel('|V_C / V_s|'); title('LC circuit gain (resonance at 1000 rad/s)')
```

</details>

---

### KP G6 多节点电路 → 联立 ODE → dsolve ★★★ 🎯（v2 新增，W13 Ex5）

**列方程的套路**：对每个有电容的节点，"流出"电流之和 = 0：

$$C_k\frac{dv_k}{dt} + \sum_{\text{邻居 } j}\frac{v_k - v_j}{R_{kj}} = 0$$

（接地的邻居 $v_j = 0$；接电源的邻居 $v_j = v_s$）

- 几个独立电容 → 几个未知函数 → 几个一阶方程
- `S = dsolve([eq1, eq2], [cond1, cond2]); S.v1, S.v2`（结构体写法，避免覆盖同名符号函数）
- **稳态检查**：令所有导数 = 0（电容开路），剩下纯电阻分压
- **时间常数**：把方程写成 $\dot{\mathbf v} = A\mathbf v + B v_s$，`eig(A)` 就是解里指数的系数（KP I2）
- 同一组方程也能直接交给 `ode45`（KP H3）

完整原题：**CP T5**。

---

## Part H — ODE 数值解 + RLC 暂态（W10）

### KP H1 向量场 quiver 与稳定性直觉 ★★

在 (t, y) 平面每点画一个方向 (1, dy/dt) 的小箭头，解曲线就是"顺着箭头流"。

```matlab
dydt = @(t, y) -2*y;
[T, Y] = meshgrid(-4:0.5:4, -4:0.5:4);
U = ones(size(T)); V = dydt(T, Y);
quiver(T, Y, U, V); xlabel('t'); ylabel('y')
```

注意区分：这里横轴是**时间**；KP H4 的**相平面图**横轴是一个状态、纵轴是另一个状态（W13 Ex3）。

#### ✅ CP H1

dy/dt = 2y 和 dy/dt = −2y 的向量场各是什么样？哪个稳定？

<details>
<summary>答案</summary>

2y：箭头背离 y = 0，越远越陡 → 不稳定；−2y：箭头指向 y = 0 → 稳定

</details>

---

### KP H2 自治系统与平衡点 ★★

- **自治**：$\frac{dy}{dt} = f(y)$，右边不显含 t —— 只要知道当前 y，就知道下一步往哪走
- 平衡点：$f(y^*) = 0$
- **稳定判据**：$f'(y^*) < 0$ 稳定（偏离后被拉回），$f'(y^*) > 0$ 不稳定

#### ✅ CP H2

dx/dt = x² − x：找平衡点并判断稳定性；x₀ = 0.9、1.1、−1 时解最终去哪？

<details>
<summary>答案</summary>

x² − x = 0 → x* = 0、1；f'(x) = 2x − 1
x* = 0：f' = −1 → **稳定**；x* = 1：f' = +1 → **不稳定**
x₀ = 0.9 → 趋于 0；x₀ = 1.1 → 发散到 +∞（有限时间爆掉）；x₀ = −1 → 趋于 0

</details>

---

### KP H3 高阶 ODE → 一阶方程组 ★★★ 🎯

**套路**：令 $x_1 = y$，$x_2 = \dot y$，$x_3 = \ddot y$ …，函数返回**列向量**。

例：$\ddot y + \dot y = y$ → $\dot x_1 = x_2$，$\dot x_2 = x_1 - x_2$

```matlab
function dydt = twoDEs(t, y)
dydt = zeros(2,1);          % 必须是列向量
dydt(1) = y(2);
dydt(2) = y(1) - y(2);
end
% 或匿名函数：
f = @(t, y) [y(2); y(1) - y(2)];
```

🎯 W13 Ex3（Lotka-Volterra，CP T3）本身就是两个耦合的一阶方程，直接写成 `@(t, p) [式1; 式2]`。

#### ✅ CP H3

把下面两个 ODE 写成状态方程（匿名函数）：
(a) 串联 RLC：$LC\ddot v_C + RC\dot v_C + v_C = V_s$
(b) $\ddot y + 4\dot y = y/6$

<details>
<summary>答案</summary>

(a) $x_1 = v_C$，$x_2 = \dot v_C$：`f = @(t,x) [x(2); (Vs - x(1) - R*C*x(2)) / (L*C)];`
(b) `f = @(t,y) [y(2); y(1)/6 - 4*y(2)];`

</details>

---

### KP H4 ode45 ★★★ 🎯

```matlab
[t, Y] = ode45(f, [t0 tf], y0);     % 所有 MATLAB ODE solver 语法相同
plot(t, Y(:,1))                     % Y 的第 k 列 = 第 k 个状态
[t, Y] = ode45(f, 0:0.01:5, y0);    % 想要固定输出时刻就传向量
plot(Y(:,1), Y(:,2))                % 相平面图：一个状态对另一个状态
```

- `ode45` = 自适应步长的 Runge-Kutta(4,5)，几乎总是第一个该试的
- **y0 的长度 = 状态个数**；t 默认是非均匀的
- 非自治（右边含 t）写法完全一样
- 🎯 **相平面图**（W13 Ex3 "plot the populations against each other"）：横轴第 1 个状态，纵轴第 2 个状态，时间不出现在图上。闭合曲线 = 周期解，螺旋向内 = 衰减振荡
- 🎯 题目给了输出时刻（如 `tYears = 0:0.05:100`）就直接传这个向量，输出行数 = 向量长度

#### ✅ CP H4（非自治）

dy/dt = −y − 2cos t，y(0) = 1，在 [0, 8] 上用 `ode45` 求解并作图；手求解析解并比较。系统稳定吗？

<details>
<summary>答案</summary>

解析：设 $y_p = A\cos t + B\sin t$，代入 $y' + y = -2\cos t$ → $A + B = -2$，$B - A = 0$ → A = B = −1
$y = 2e^{-t} - \cos t - \sin t$（由 y(0) = 1 得 C = 2）

```matlab
f = @(t, y) -y - 2*cos(t);
[t, y] = ode45(f, [0 8], 1);
yex = 2*exp(-t) - cos(t) - sin(t);
plot(t, y, 'o', t, yex, '-'); legend('ode45', 'exact'); grid on
xlabel('t'); ylabel('y'); title('dy/dt = -y - 2cos(t)')
max(abs(y - yex))     % ~2.6e-4（默认容差）
```

稳定：齐次部分 $2e^{-t}$ 衰减，最后剩下有界的稳态振荡（幅度 √2）。

</details>

---

### KP H5 Euler 法与 RK4（自己写求解器）★★

**Euler**（沿切线走一步，误差 O(h)）：

$$y_{n+1} = y_n + h\,f(t_n, y_n)$$

**RK4**（取四个斜率加权平均，误差 O(h⁴)）：

$$k_1 = f(t_n, y_n),\quad k_2 = f(t_n + \tfrac h2, y_n + \tfrac h2 k_1),\quad k_3 = f(t_n + \tfrac h2, y_n + \tfrac h2 k_2),\quad k_4 = f(t_n + h, y_n + hk_3)$$
$$y_{n+1} = y_n + \tfrac h6(k_1 + 2k_2 + 2k_3 + k_4)$$

#### ✅ CP H5a（手算）

y' = −2y，y(0) = 1，h = 0.1，Euler 走两步，与精确值比较。

<details>
<summary>答案</summary>

y₁ = 1 + 0.1·(−2) = 0.8；y₂ = 0.8 + 0.1·(−1.6) = 0.64；精确 e^{−0.4} = 0.6703（误差约 4.5%）

</details>

#### ✅ CP H5b（代码）

写 Euler 和 RK4 循环，h = 0.1 积分到 t = 1，比较 e^{−2}。Euler 的 h 超过多少会不稳定？

<details>
<summary>答案</summary>

```matlab
f = @(t, y) -2*y;
h = 0.1; N = 10; t = 0;
ye = 1; yr = 1;
for n = 1:N
    ye = ye + h*f(t, ye);
    k1 = f(t, yr);
    k2 = f(t + h/2, yr + h/2*k1);
    k3 = f(t + h/2, yr + h/2*k2);
    k4 = f(t + h, yr + h*k3);
    yr = yr + h/6*(k1 + 2*k2 + 2*k3 + k4);
    t = t + h;
end
fprintf('Euler %.5f, RK4 %.5f, exact %.5f\n', ye, yr, exp(-2));
% Euler 0.10737, RK4 0.13534, exact 0.13534
```

Euler 每步乘 (1 − 2h)，要 |1 − 2h| < 1 → **h > 1 时发散**（0.5 < h < 1 时符号交替振荡但仍衰减）。

</details>

---

### KP H6 RLC 阶跃响应（完整解）★★★

串联 RLC，t = 0 接直流 Vs，输出 v_C：

$$V_s = LC\frac{d^2v_C}{dt^2} + RC\frac{dv_C}{dt} + v_C$$

**① 稳态（特解）**：令导数 = 0，或 C 开路、L 短路 → $v_C(\infty) = V_s$

**② 暂态（齐次解）**：特征方程 $Ls^2 + Rs + \frac1C = 0$

$$\alpha = \frac{R}{2L}\ \text{（串联；并联为 } \tfrac{1}{2RC}\text{）},\qquad \omega_0 = \frac{1}{\sqrt{LC}}$$

| 情况 | 条件 | 根 | 解的形式 |
|---|---|---|---|
| 过阻尼 | α > ω₀ | 两个不同负实根 s₁, s₂ | $V_s + k_1e^{s_1t} + k_2e^{s_2t}$ |
| 临界阻尼 | α = ω₀ | 重根 | （slides 说不深入） |
| 欠阻尼 | α < ω₀ | −α ± jω_d，$\omega_d = \sqrt{\omega_0^2 - \alpha^2}$ | $V_s + Ae^{-\alpha t}\cos(\omega_dt + \theta)$ |

**③ 初值定常数**：$v_C(0^+) = v_C(0^-)$（电容电压连续），$\dot v_C(0^+) = i(0^+)/C$（电感电流连续）。零初始储能时两者都是 0。

#### ✅ CP H6a

L = 1 H，C = 0.25 F。R = 1、4、5 Ω 时分别是什么阻尼？算出根（或 ω_d）。

<details>
<summary>答案</summary>

ω₀ = 1/√0.25 = 2
- R = 1：α = 0.5 < 2 → **欠阻尼**，ω_d = √(4 − 0.25) = 1.936
- R = 4：α = 2 = ω₀ → **临界阻尼**，重根 −2
- R = 5：α = 2.5 > 2 → **过阻尼**，s = −2.5 ± √(6.25 − 4) = **−1, −4**

</details>

#### ✅ CP H6b

R = 5 Ω 的情况，Vs = 1 V，零初值：手求 v_C(t)，再用 `dsolve` 和 `ode45` 验证，三者画在一张图上。

<details>
<summary>答案</summary>

$v_C = 1 + k_1e^{-t} + k_2e^{-4t}$
$v_C(0) = 0$：$1 + k_1 + k_2 = 0$
$\dot v_C(0) = 0$：$-k_1 - 4k_2 = 0$ → $k_1 = -4k_2$ → $-3k_2 = -1$
→ $k_2 = 1/3$，$k_1 = -4/3$
**$v_C(t) = 1 - \tfrac43e^{-t} + \tfrac13e^{-4t}$**

```matlab
L = 1; C = 0.25; R = 5; Vs = 1;
% dsolve
syms v(t)
Dv = diff(v, t);
vs(t) = dsolve(L*C*diff(v,t,2) + R*C*diff(v,t) + v == Vs, [v(0) == 0, Dv(0) == 0]);
% ode45
f = @(t, x) [x(2); (Vs - x(1) - R*C*x(2)) / (L*C)];
[tn, xn] = ode45(f, [0 6], [0; 0]);
% plot
figure; fplot(vs, [0 6], 'LineWidth', 2, 'DisplayName', 'dsolve'); hold on
plot(tn, xn(:,1), 'o', 'DisplayName', 'ode45');
plot(tn, 1 - 4/3*exp(-tn) + 1/3*exp(-4*tn), 'k--', 'DisplayName', 'hand');
xlabel('t (s)'); ylabel('v_C (V)'); title('Overdamped series RLC step response');
legend('Location', 'southeast'); grid on; hold off
```

</details>

---

### KP H7 叠加原理 ★

- 完整响应 = **零输入响应**（只有初值，无输入）+ **零状态响应**（零初值，只有输入）
- 分段常数输入 = 若干个延迟阶跃之和 → 输出 = 各阶跃响应之和

#### ✅ CP H7

dy/dt = −y + u，y(0) = 2，u = 1（阶跃）。分别写出零输入、零状态、完整响应。

<details>
<summary>答案</summary>

零输入：2e^{−t}；零状态：1 − e^{−t}；完整：**1 + e^{−t}**

</details>

---

## Part I — 稳定性 / AC 频响 / Laplace（W11）

### KP I1 矩阵形式与矩阵指数 ★★

$$\frac{d\mathbf y}{dt} = M\mathbf y \;\Rightarrow\; \mathbf y(t) = e^{tM}\mathbf y_0,\qquad e^{tM} = I + tM + \frac{t^2}{2!}M^2 + \cdots$$

MATLAB：`expm(t*M)`（**不是** `exp`，`exp` 是逐元素指数）

#### ✅ CP I1

$M = \begin{bmatrix}0&1\\-2&-3\end{bmatrix}$（即 y'' + 3y' + 2y = 0），$\mathbf y_0 = [1; 0]$。用 `expm` 求 t = 1 时的状态，并与 CP G2a 的解析解比较。

<details>
<summary>答案</summary>

```matlab
M = [0 1; -2 -3];
expm(1*M) * [1; 0]                         % [0.6004; -0.4651]
[2*exp(-1) - exp(-2); -2*exp(-1) + 2*exp(-2)]   % 相同
```

状态 = [y; y']，y = 2e^{−t} − e^{−2t}，y' = −2e^{−t} + 2e^{−2t}

</details>

---

### KP I2 用特征值给平衡点分类 ★★★

**直觉**：特征向量是"直线轨迹"的方向，特征值决定沿这个方向是被拉进来（Re < 0）还是推出去（Re > 0）；虚部表示旋转。

| 特征值（a, b, c > 0） | 类型 | 稳定性 | slides 例子 M |
|---|---|---|---|
| +a, +b | source node | 不稳定 | [2 1; 1 3] |
| −a, −b | sink node | 稳定 | [−2 −1; −1 −3] |
| −a, +b | saddle | **永远不稳定** | [2 1; 1 −3] |
| −a ± jc | sink focus（螺旋汇） | 稳定 | [−2 −1; 1 −2] |
| +a ± jc | source focus（螺旋源） | 不稳定 | [2 1; −1 2] |
| ±jc | centre | 稳定（闭合轨道，非双曲） | [1 2; −2 −1] |

- **双曲**（所有 Re(λ) ≠ 0）：全部 Re < 0 → 渐近稳定；任一 Re > 0 → 不稳定
- **2×2 速判**：$\lambda^2 - \text{tr}(M)\lambda + \det(M) = 0$
  - det < 0 → saddle
  - det > 0 且 tr < 0 → 稳定（tr² ≥ 4det 是 node，否则 focus）
  - tr = 0 且 det > 0 → centre
- **🔗 全课程最重要的连接**：伴随矩阵（companion matrix）的特征值 = ODE 特征方程的根 = 传递函数的极点

#### ✅ CP I2a

不用电脑，判断这些矩阵的平衡点类型：
① [2 1; 1 −3]　② [−2 −1; 1 −2]　③ [1 2; −2 −1]　④ [0 1; −2 −3]　⑤ [0 1; −4 0]

<details>
<summary>答案</summary>

| | tr | det | 特征值 | 类型 |
|---|---|---|---|---|
| ① | −1 | −7 | 2.19, −3.19 | saddle，不稳定 |
| ② | −4 | 5 | −2 ± j | sink focus，稳定 |
| ③ | 0 | 3 | ±j1.732 | centre，稳定 |
| ④ | −3 | 2 | −1, −2 | sink node，稳定（= y''+3y'+2y=0） |
| ⑤ | 0 | 4 | ±2j | centre（= 无阻尼振荡 y''+4y=0） |

</details>

#### ✅ CP I2b（代码）

写函数 `type = classifyEq(M)`，输入 2×2 矩阵，返回分类字符串（node/saddle/focus/centre + stable/unstable）。

<details>
<summary>答案</summary>

```matlab
function type = classifyEq(M)
lam = eig(M);
re = real(lam); im = imag(lam);
tol = 1e-10;
if all(abs(re) < tol) && all(abs(im) > tol)
    type = 'centre (stable, non-hyperbolic)';
elseif any(abs(re) < tol)
    type = 'non-hyperbolic (zero real part)';
elseif all(abs(im) < tol)                 % 实特征值
    if all(re < 0),     type = 'sink node (stable)';
    elseif all(re > 0), type = 'source node (unstable)';
    else,               type = 'saddle (unstable)';
    end
else                                      % 复特征值，实部非零
    if all(re < 0), type = 'sink focus (stable)';
    else,           type = 'source focus (unstable)';
    end
end
end
```

</details>

---

### KP I3 AC 稳态 RLC：谐振与相位变化 ★★★

串联 RLC：$Z = R + j\left(\omega L - \frac{1}{\omega C}\right)$，$|Z| = \sqrt{R^2 + (\omega L - \frac{1}{\omega C})^2}$

- **谐振** $\omega_0 = 1/\sqrt{LC}$：电抗抵消，|Z| = R 最小，电流最大，相位 0
- ω → 0：电容主导（容性），**电流超前**电压最多 90°
- ω → ∞：电感主导（感性），**电流滞后**电压最多 90°
- 穿过谐振，相位共变化 180°

#### ✅ CP I3

R = 10 Ω，L = 10 mH，C = 100 μF。分别求 ω = 500、1000、2000 rad/s 时的 Z 和电流相对电压的相位。

<details>
<summary>答案</summary>

| ω | ωL | 1/(ωC) | Z | ∠I（相对 V） |
|---|---|---|---|---|
| 500 | 5 | 20 | 10 − j15 | **+56.3°**（超前，容性） |
| 1000 | 10 | 10 | 10 | 0°（谐振） |
| 2000 | 20 | 5 | 10 + j15 | **−56.3°**（滞后，感性） |

∠I = −∠Z = −atan(X/R)

</details>

---

### KP I4 频响曲线：符号法 vs 数值法 ★★★ 🎯

```matlab
% 符号法（slides 用的方法）
syms w real
g = subs(G, s, 1j*w);              % s → jω
fplot(abs(g), [0 wmax]); grid on   % slides 里是 ezplot

% 数值法（更快，推荐）
w = logspace(0, 5, 500);
H = 1 ./ (1 + 1j*w*RC);            % 例子
semilogx(w, 20*log10(abs(H)));      % dB
```

🎯 W13 Ex4（CP T4）就是下面 CP I4 这个电路，参数换成 C1 = 0.02 F、C2 = 0.01 F，并且**幅度和相位都要画**（`angle`、`rad2deg`）。

#### ✅ CP I4（W11 例子电路）

vs → [C1 ∥ R1] 串联 → 输出节点 v，节点对地接 [C2 ∥ R2]。C1 = 2 mF，C2 = 1 mF，R1 = R2 = 1 Ω。
(a) 用 KCL 推导 $H(\omega) = v/v_s$
(b) ω → 0 和 ω → ∞ 时的增益
(c) |H(1000)|
(d) 画 |H| 随 ω 变化

<details>
<summary>答案</summary>

(a) $Y_1 = \frac{1}{R_1} + j\omega C_1$，$Y_2 = \frac{1}{R_2} + j\omega C_2$；KCL：$(v_s - v)Y_1 = vY_2$
→ $H = \frac{Y_1}{Y_1 + Y_2} = \frac{1 + j0.002\omega}{2 + j0.003\omega}$

(b) ω → 0：电容开路，电阻分压 → **1/2**；ω → ∞：电容短路主导，电容分压 → $\frac{C_1}{C_1 + C_2}$ = **2/3**

(c) $\frac{|1 + 2j|}{|2 + 3j|} = \frac{\sqrt5}{\sqrt{13}}$ = **0.620**（相位 +7.1°）

(d)
```matlab
C1 = 2e-3; C2 = 1e-3; R1 = 1; R2 = 1;
H = @(w) (1/R1 + 1j*w*C1) ./ (1/R1 + 1j*w*C1 + 1/R2 + 1j*w*C2);
w = logspace(0, 5, 500);
semilogx(w, abs(H(w))); grid on
xlabel('\omega (rad/s)'); ylabel('|v / v_s|'); title('Gain of the C1||R1 - C2||R2 network')
```

</details>

---

### KP I5 Laplace 变换 ★★★ 🎯

$$F(s) = \mathcal L\{f(t)\} = \int_{0^-}^{\infty}e^{-st}f(t)\,dt$$

**一句话**：Laplace 把**微分变成乘 s**，微分方程变成代数方程。

| f(t) | F(s) |
|---|---|
| δ(t) | 1 |
| u(t)（阶跃） | 1/s |
| t | 1/s² |
| $e^{-at}$ | 1/(s+a) |
| cos ωt | s/(s² + ω²) |
| sin ωt | ω/(s² + ω²) |
| dy/dt | sY(s) − y(0) |

- s 域阻抗：$Z_R = R$，$Z_L = sL$，$Z_C = \frac{1}{sC}$ → 和相量法**完全一样的电路分析**，只是 jω 换成 s
- 传递函数 = 输出 / 输入的 Laplace 变换比（零初值）
- **s = jω 时就是频率响应**；用 `ilaplace` 能得到**完整响应**（暂态 + 稳态）
- 🎯 W13 Ex4 第 2 问（CP T4）：同一个电路，用 `ilaplace(G*laplace(cos(100*t)))` 求 v(t)；它的稳态部分要和第 1 问的 |H(j100)|、∠H(j100) 一致

```matlab
syms t s
laplace(cos(w*t), t, s)    % s/(s^2 + w^2)
ilaplace(F, s, t)
```

#### ✅ CP I5（W11 Laplace 例子）

vs → R1 = 1 Ω 串联 → 节点 v，节点对地接 C = 1 mF ∥ R2 = 1 Ω。
(a) 用符号法推导 G(s) = V/Vs
(b) DC 增益、极点、时间常数
(c) 输入 $v_s = \cos(10^4t)$，用 `ilaplace` 求 v(t)，指出暂态和稳态部分
(d) 用 G(jω) 直接算稳态幅度，与 (c) 对照

<details>
<summary>答案</summary>

```matlab
syms vs v s t
R1 = 1; R2 = 1; C1 = 1e-3;
y1 = 1/R1;                   % 上支路导纳
y2 = s*C1 + 1/R2;            % 下支路导纳
nodeI = (vs - v)*y1 - v*y2;  % KCL
v1 = solve(nodeI, v);        % 1000*vs/(s + 2000)
G = simplify(v1/vs)          % 1000/(s + 2000)
v3 = ilaplace(G*laplace(cos(1e4*t), t, s), s, t);
simplify(v3)
fplot(v3, [0 0.005]); grid on; xlabel('t'); ylabel('v(t)')
```

(a) **G(s) = 1000/(s + 2000)**
(b) DC 增益 G(0) = **0.5**（电阻分压）；极点 **−2000**；时间常数 **0.5 ms**；也是一个截止频率 2000 rad/s 的低通
(c) $v(t) = \frac{1}{52}\left[\cos(10^4t) + 5\sin(10^4t)\right] - \frac{1}{52}e^{-2000t}$，t ≥ 0
　前半是**稳态**（正弦），后半是**暂态**（按极点 −2000 衰减）
(d) $|G(j10^4)| = \frac{1000}{|2000 + j10^4|} = 0.0981$；(c) 稳态幅度 $\frac{\sqrt{1^2 + 5^2}}{52} = 0.0981$ ✓

</details>

---

## Part J — LTI 系统（W12）

### KP J1 LTI 的两个性质 ★★

- **线性**：$G(\alpha u + \beta v) = \alpha G(u) + \beta G(v)$
- **时不变**：输入延迟 r，输出也只是延迟 r

#### ✅ CP J1

(a) y = 2u + 3 是线性的吗？(b) y(t) = t·u(t) 是时不变的吗？

<details>
<summary>答案</summary>

(a) 不是：G(0) = 3 ≠ 0，叠加不成立（这是"仿射"）　(b) 不是：系数 t 随时间变，输入延迟后输出不等于原输出的延迟

</details>

---

### KP J2 ODE → 传递函数 ★★★

零初值下 $\frac{d^n}{dt^n} \to s^n$：

$$\dddot y + 4\ddot y + 14\dot y + 20y = 3\dot u + 3u \;\Rightarrow\; G(s) = \frac{Y(s)}{U(s)} = \frac{3s + 3}{s^3 + 4s^2 + 14s + 20}$$

```matlab
G = tf([3 3], [1 4 14 20]);   % 分子、分母系数，降幂
s = tf('s');  G = (3*s + 3)/(s^3 + 4*s^2 + 14*s + 20);   % 等价写法
pole(G); zero(G);
```

#### ✅ CP J2

上面这个 G(s) 的极点、零点？系统稳定吗？

<details>
<summary>答案</summary>

`pole(G)` = −2, −1 ± 3j；`zero(G)` = −1；所有极点实部 < 0 → **稳定**

</details>

---

### KP J3 串联 RLC 的传递函数 + 参数 ★★★

用 s 域分压（v_C 为输出）：

$$G(s) = \frac{1/(sC)}{R + sL + 1/(sC)} = \frac{1}{LCs^2 + RCs + 1}$$

$$\alpha = \frac{R}{2L},\quad \omega_0 = \frac{1}{\sqrt{LC}},\quad \zeta = \frac{\alpha}{\omega_0}\ \text{（阻尼比）}$$

ζ < 1 欠阻尼，ζ = 1 临界，ζ > 1 过阻尼

**slides 的三种表示法**（都要认识）：

| 表示 | 变量 | 用途 |
|---|---|---|
| ① 直接电路法 | `syms omega`，Z 用 jωL | 稳态频响 `fplot(abs(G))` |
| ② Laplace 符号法 | `syms s`，Z 用 sL | `ilaplace(G*laplace(1,t,s))` 求完整阶跃响应 |
| ③ tf 对象 | `s = tf('s')` | `step(G)`、`bode(G)` |

#### ✅ CP J3

L = 1 H，C = 0.25 F，R = 5 Ω：
(a) 写出 G(s)，求 ζ
(b) 用三种方法求单位阶跃响应并画在一起（应和 CP H6b 完全一致）

<details>
<summary>答案</summary>

(a) $G = \frac{1}{0.25s^2 + 1.25s + 1} = \frac{4}{s^2 + 5s + 4}$；α = 2.5，ω₀ = 2，**ζ = 1.25（过阻尼）**

(b)
```matlab
L = 1; C = 0.25; R = 5;

% ② Laplace 符号法
syms s t
G2 = (1/(s*C)) / (R + s*L + 1/(s*C));
vL = ilaplace(G2 * laplace(sym(1), t, s), s, t);   % 1 - 4/3 e^{-t} + 1/3 e^{-4t}

% ③ tf 对象
st = tf('s');
G3 = (1/(st*C)) / (R + st*L + 1/(st*C));
G3 = minreal(G3);            % 约掉多余的 s，得到 4/(s^2+5s+4)
[y3, t3] = step(G3, 6);

% ODE（Part H）
f = @(t, x) [x(2); (1 - x(1) - R*C*x(2)) / (L*C)];
[t4, x4] = ode45(f, [0 6], [0; 0]);

figure; fplot(vL, [0 6], 'LineWidth', 2, 'DisplayName', 'ilaplace'); hold on
plot(t3, y3, '--', 'LineWidth', 2, 'DisplayName', 'step()');
plot(t4, x4(:,1), 'o', 'DisplayName', 'ode45');
xlabel('t (s)'); ylabel('v_C (V)'); title('Series RLC step response, three methods');
legend('Location', 'southeast'); grid on; hold off
```

实测 `step` 与解析解最大误差 ~1e-15，`ode45` ~1e-5。

</details>

---

### KP J4 零极点增益 ZPK ★★

$$G(s) = K\frac{(s - z_1)(s - z_2)\cdots}{(s - p_1)(s - p_2)\cdots}$$

- **零点**：分子 = 0；**极点**：分母 = 0（= 系统的自然频率 = 特征方程的根）
- 稳定 ⇔ 所有极点 Re < 0

```matlab
G2 = zpk(-1, [-2; -1+3j; -1-3j], 3);
[z, p, k] = zpkdata(G2, 'v');
```

#### ✅ CP J4

证明 `zpk(-1, [-2; -1+3j; -1-3j], 3)` 和 CP J2 的 G 是同一个系统。

<details>
<summary>答案</summary>

$(s+2)(s^2 + 2s + 10) = s^3 + 4s^2 + 14s + 20$（共轭复根 −1 ± 3j 对应 $(s+1)^2 + 9$）；分子 3(s + 1) = 3s + 3 ✓

</details>

---

### KP J5 状态空间 ★★★

$$\dot{\mathbf x} = A\mathbf x + B u,\qquad y = C\mathbf x + Du$$

和 Part H3 "高阶 ODE → 一阶方程组"**是同一件事**。n 阶 ODE $y^{(n)} + a_{n-1}y^{(n-1)} + \cdots + a_0y = u$ 的**伴随型（companion form）**：

$$A = \begin{bmatrix}0&1&0&\cdots&0\\0&0&1&\cdots&0\\\vdots&&&\ddots&\vdots\\-a_0&-a_1&-a_2&\cdots&-a_{n-1}\end{bmatrix},\quad B = \begin{bmatrix}0\\\vdots\\0\\1\end{bmatrix},\quad C = [1\ 0\ \cdots\ 0]$$

分子有 $b_1s + b_0$ 时 → $C = [b_0\ b_1\ 0\ \cdots]$

- 与 TF 的关系：$G(s) = C(sI - A)^{-1}B + D$
- **eig(A) = 极点**
- 表示不唯一，但阶数唯一
- 转换：`ss(G)`、`tf(sys)`、`zpk(sys)`；提取：`tfdata`、`zpkdata`、`ssdata`

#### ✅ CP J5

为 CP J2 的系统写出 A、B、C、D，用 `ss` 建模，验证 `tf(sys)` 还原出原 G，`eig(A)` 等于极点。

<details>
<summary>答案</summary>

```matlab
A = [0 1 0; 0 0 1; -20 -14 -4];
B = [0; 0; 1];
C = [3 3 0];
D = 0;
sys = ss(A, B, C, D);
[num, den] = tfdata(tf(sys), 'v')   % num = [0 0 3 3], den = [1 4 14 20]
eig(A)                              % -2, -1±3j
```

为什么 C = [3 3 0]：令 $X(s) = U(s)/\text{den}(s)$，状态 $x_1 = x,\ x_2 = \dot x$，则 $y = 3\dot x + 3x = 3x_2 + 3x_1$。

</details>

---

### KP J6 方框图连接 ★★★

| 连接 | 结果 | MATLAB |
|---|---|---|
| 串联（cascade） | $G_1G_2$ | `G1*G2` |
| 并联 | $G_1 + G_2$ | `G1 + G2` |
| 负反馈 | $\frac{G_1}{1 + G_1G_2}$ | `feedback(G1, G2)` |

#### ✅ CP J6

$G_1 = \frac{10}{s+1}$。求：(a) 单位负反馈闭环 TF 及 DC 增益；(b) 与 $\frac{1}{s+2}$ 串联；(c) 与 1 并联。闭环后极点怎么移动？

<details>
<summary>答案</summary>

(a) $\frac{10/(s+1)}{1 + 10/(s+1)} = \frac{10}{s + 11}$，DC 增益 **10/11 ≈ 0.909**；极点从 −1 移到 **−11**（响应快了 11 倍，代价是 DC 增益 < 1）
(b) $\frac{10}{(s+1)(s+2)}$　(c) $\frac{s + 11}{s + 1}$

```matlab
G1 = tf(10, [1 1]);
Gc = feedback(G1, 1); dcgain(Gc)
G1 * tf(1, [1 2])
G1 + 1
```

</details>

---

### KP J7 bode 与 step ★★★

- **Bode 图**：横轴 log₁₀ ω，幅度用 dB = $20\log_{10}|G(j\omega)|$，另画相位
- `bode(G)`、`[mag, phase, w] = bode(G)`
- `step(G)`、`impulse(G)`、`dcgain(G)`（= G(0)）、`stepinfo(G)`
- 稳定系统的**阶跃终值 = DC 增益 G(0)**

#### ✅ CP J7

$G = \frac{s + 2}{s^2 + 2s + 1}$：DC 增益、极点、阶跃终值、阶跃响应表达式，有没有超调？高频时幅度以多少 dB/dec 下降？

<details>
<summary>答案</summary>

DC 增益 = 2/1 = **2** = 阶跃终值；极点 **−1（二重）**

$Y = \frac{s+2}{s(s+1)^2} = \frac{2}{s} - \frac{2}{s+1} - \frac{1}{(s+1)^2}$ → $y(t) = 2 - 2e^{-t} - te^{-t}$

$\dot y = e^{-t}(1 + t) > 0$ 恒成立 → 单调上升，**无超调**
相对阶次 = 2 − 1 = 1 → 高频 **−20 dB/dec**，相位趋于 −90°

```matlab
G = tf([1 2], [1 2 1]);
figure; bode(G); grid on
figure; step(G); grid on
```

</details>

---

### KP J8 非线性系统的线性化 ★

slides 只在 outline 提到。思路：在平衡点 x* 附近用 Jacobian 近似，$\dot{\delta x} \approx J(x^*)\,\delta x$，然后对 J 做 Part I2 的特征值分析。CP H2 的 $f'(x^*)$ 就是一维情形。

#### ✅ CP J8

无阻尼单摆 $\ddot\theta = -\sin\theta$。写成状态方程，在平衡点 (0, 0) 和 (π, 0) 处线性化并分类。

<details>
<summary>答案</summary>

$x_1 = \theta$，$x_2 = \dot\theta$：$\dot x_1 = x_2$，$\dot x_2 = -\sin x_1$
$J = \begin{bmatrix}0 & 1\\ -\cos x_1 & 0\end{bmatrix}$

- (0, 0)：$J = \begin{bmatrix}0&1\\-1&0\end{bmatrix}$，特征值 ±j → **centre**（在最低点附近来回摆）
- (π, 0)：$J = \begin{bmatrix}0&1\\1&0\end{bmatrix}$，特征值 ±1 → **saddle**（倒立，不稳定）

```matlab
syms x1 x2 real
F = [x2; -sin(x1)];
J = jacobian(F, [x1, x2]);
eig(double(subs(J, [x1 x2], [0 0])))
eig(double(subs(J, [x1 x2], [pi 0])))
```

</details>

---

## Part K — 综合模拟题（考试风格）

> 每题都按 quiz 结构：个人参数 → 建模 → 指定方法求解 → 带标签输出 → 专业作图。限时 40 分钟写完再看答案。

### 🧪 Mock 1 — RLC 电路的 LTI 分析

参数：R = S（Ω，学号后四位之和，为 0 取 1），L = 0.1 H，C = 100 μF。

1. 用 `tf` 建立串联 RLC 的传递函数 $G(s) = V_C/V_s$，显示极点，计算 α、ω₀、ζ 并判断阻尼类型
2. 把电路 ODE 写成状态方程，用 `ode45` 求零初值单位阶跃响应；与 `step(G)` 画在同一张图上
3. 画 Bode 图
4. 输入 $v_s = \cos(\omega_0t)$，稳态 $v_C$ 的幅度是多少？用 $|G(j\omega_0)|$ 计算，并说明它和 ζ 的关系

<details>
<summary>答案</summary>

```matlab
clear; clc; close all;
S = 16; if S == 0, S = 1; end
R = S; L = 0.1; C = 100e-6;

%% 1. Transfer function
s = tf('s');
G = 1 / (L*C*s^2 + R*C*s + 1);
p = pole(G);
alpha = R/(2*L); omega0 = 1/sqrt(L*C); zeta = alpha/omega0;
disp('Poles of G(s):'); disp(p);
fprintf('alpha = %.2f, omega0 = %.2f rad/s, zeta = %.3f\n', alpha, omega0, zeta);
if zeta < 1
    disp('Underdamped');
elseif zeta == 1
    disp('Critically damped');
else
    disp('Overdamped');
end

%% 2. ode45 vs step
f = @(t, x) [x(2); (1 - x(1) - R*C*x(2)) / (L*C)];
Tend = 10/alpha;                         % 约 10 个衰减时间常数
[tn, xn] = ode45(f, [0 Tend], [0; 0]);
[ys, ts] = step(G, Tend);
figure('Color', 'white');
plot(ts, ys, 'b-', 'LineWidth', 2, 'DisplayName', 'step(G)'); hold on
plot(tn, xn(:,1), 'ro', 'MarkerSize', 4, 'DisplayName', 'ode45');
xlabel('t (s)'); ylabel('v_C (V)');
title(sprintf('Series RLC unit-step response (R = %d \\Omega, \\zeta = %.3f)', R, zeta));
legend('Location', 'southeast'); grid on; hold off

%% 3. Bode
figure; bode(G); grid on; title('Bode diagram of series RLC (output v_C)');

%% 4. Steady-state amplitude at omega0
A0 = abs(evalfr(G, 1j*omega0));          % 或 abs(freqresp(G, omega0))
fprintf('|G(j omega0)| = %.4f, 1/(2 zeta) = %.4f\n', A0, 1/(2*zeta));
```

S = 16 时：ω₀ = 316.23 rad/s，α = 80，ζ = 0.253 → **欠阻尼**，极点 −80 ± j305.9。
(4) 在 ω₀ 处 $G(j\omega_0) = \frac{1}{jRC\omega_0}$，$|G(j\omega_0)| = \frac{1}{RC\omega_0} = \frac{1}{2\zeta}$ = **1.976**（就是品质因数 Q：ζ 越小，谐振峰越高）。
因为 S ≤ 36 而临界电阻 $2\sqrt{L/C} = 63.2$ Ω，所以这组参数**永远是欠阻尼**。

</details>

---

### 🧪 Mock 2 — 到达过程仿真

参数：λ = S/10 个/秒（S 为 0 取 1），总时长 T = 1000 秒。

1. 用 Exponential 分布生成到达间隔，累加得到到达时刻（直到超过 T）
2. 统计每个 1 秒窗口内的到达数
3. 在一张图上画到达数的**归一化**直方图，叠加理论 Poisson(λ) pmf
4. 分别用仿真和理论计算 P(某一秒内到达数 > 2λ)
5. 用 `fitdist` 从仿真的间隔数据估计 λ

<details>
<summary>答案</summary>

```matlab
clear; clc; close all;
S = 16; if S == 0, S = 1; end
lambda = S/10; T = 1000;
rng(1);

%% 1. Inter-arrival times -> arrival times
pe = makedist('Exponential', 'mu', 1/lambda);      % mu = mean = 1/lambda
gaps = pe.random(ceil(2*lambda*T), 1);             % 多生成一些，保证够用
arrivals = cumsum(gaps);
arrivals = arrivals(arrivals <= T);

%% 2. Counts per 1-second window
counts = histcounts(arrivals, 0:1:T)';

%% 3. Histogram vs Poisson pmf
k = 0:max(counts);
pp = makedist('Poisson', 'lambda', lambda*1);      % 窗口 1 秒 -> lambda*1
figure('Color', 'white');
histogram(counts, 'BinMethod', 'integers', 'Normalization', 'probability', ...
          'DisplayName', 'Simulated counts'); hold on
stem(k, pp.pdf(k), 'r', 'filled', 'LineWidth', 1.5, 'DisplayName', 'Poisson pmf');
xlabel('Arrivals per second'); ylabel('Probability');
title(sprintf('Arrivals per 1 s window, \\lambda = %.1f /s', lambda));
legend; grid on; hold off

%% 4. P(count > 2*lambda)
thr = 2*lambda;
p_sim = mean(counts > thr);
p_th  = 1 - pp.cdf(floor(thr));
fprintf('P(count > %.1f): simulation %.4f, theory %.4f\n', thr, p_sim, p_th);

%% 5. Estimate lambda
pdfit = fitdist(diff([0; arrivals]), 'Exponential');
fprintf('Estimated lambda = %.3f (true %.3f)\n', 1/pdfit.mu, lambda);
```

要点：`mu = 1/λ`；Poisson 参数要乘窗口长度；`floor(thr)` 是因为"> 3.2"等价于"≥ 4"即 1 − F(3)。
λ = 1.6 时理论值 P(K > 3.2) = 1 − F(3) ≈ 0.0788。

</details>

---

### 🧪 Mock 3 — 符号解 vs 数值解

参数：a = D/10，b = M（D 生日日期，M 月份，为 0 取 1）。

$$\ddot y + a\dot y + b\,y = 1,\quad y(0) = 0,\ \dot y(0) = 0$$

1. 用 `dsolve` 求解析解，用 `matlabFunction` 转成数值函数
2. 写成状态方程，用 `ode45` 求解
3. 写出伴随矩阵 A，用 `eig` 判断平衡点类型
4. 上图画两种解，下图（`subplot`）画误差

<details>
<summary>答案</summary>

```matlab
clear; clc; close all;
D = 14; M = 3;
if D == 0, D = 1; end
if M == 0, M = 1; end
a = D/10; b = M;

%% 1. Symbolic
syms y(t)
Dy = diff(y, t);
ys = dsolve(diff(y,t,2) + a*diff(y,t) + b*y == 1, [y(0) == 0, Dy(0) == 0]);
yf = matlabFunction(ys);           % numeric handle yf(t)

%% 2. Numeric
f = @(t, x) [x(2); 1 - a*x(2) - b*x(1)];
[tn, xn] = ode45(f, [0 20], [0; 0]);

%% 3. Eigen-analysis
A = [0 1; -b -a];
lam = eig(A);
disp('Eigenvalues of A:'); disp(lam);
if all(real(lam) < 0) && any(imag(lam) ~= 0)
    disp('Sink focus: stable, oscillatory (underdamped)');
elseif all(real(lam) < 0)
    disp('Sink node: stable, non-oscillatory');
else
    disp('Unstable or non-hyperbolic');
end

%% 4. Plots
figure('Color', 'white');
subplot(2,1,1);
plot(tn, yf(tn), 'b-', 'LineWidth', 2, 'DisplayName', 'dsolve'); hold on
plot(tn, xn(:,1), 'r.', 'DisplayName', 'ode45');
xlabel('t'); ylabel('y(t)'); title(sprintf('y'''' + %.1f y'' + %d y = 1', a, b));
legend('Location', 'southeast'); grid on; hold off
subplot(2,1,2);
plot(tn, abs(yf(tn) - xn(:,1)), 'k-');
xlabel('t'); ylabel('|error|'); title('ode45 error vs analytic solution'); grid on
```

D = 14、M = 3 时：a = 1.4，b = 3，特征值 −0.7 ± j1.584 → **sink focus（欠阻尼，衰减振荡）**，稳态 y → 1/b = 1/3。

</details>

---

## 附录

### A. 函数速查表

| 主题 | 函数 |
|---|---|
| 构造 | `linspace` `zeros` `ones` `eye` `rand` `randn` `meshgrid` `repmat` |
| 线代 | `\` `inv` `det` `rank` `lu` `qr(A,0)` `chol` `eig` `expm` `norm` `cond` |
| 多项式 | `polyval` `roots` `poly` `conv` `polyfit` |
| 概率 | `makedist` `fitdist` `pdf` `cdf` `icdf` `random` `rng` `unidrnd` `randperm` `randsample` |
| 统计 | `mean` `var` `std` `median` `mode` `prctile` `histogram` `boxplot` `histfit` `histcounts` |
| 符号 | `syms` `sym` `str2sym` `subs` `simplify` `expand` `factor` `collect` `solve` `vpasolve` `double` `vpa` `matlabFunction` |
| 微积分 | `diff` `int` `symsum` `taylor` `jacobian` `gradient` `hessian` `laplace` `ilaplace` |
| 非线性 | `roots` `fzero` `optimset` `fminsearch` |
| ODE | `dsolve`（含联立） `ode45` `quiver` |
| LTI | `tf` `zpk` `ss` `tfdata` `zpkdata` `ssdata` `pole` `zero` `dcgain` `evalfr` `feedback` `step` `impulse` `bode` `minreal` |
| 作图 | `figure` `plot` `scatter` `stem` `fplot` `subplot` `semilogx` `hold` `xlabel` `ylabel` `title` `legend` `grid` |
| 输出 | `disp` `fprintf` `sprintf` `num2str` |

### B. 常见坑 Top 18

1. `X^2` vs `X.^2`；匿名函数里忘记点运算
2. `linspace` 默认**行**向量，题目要列向量记得加 `'`
3. 复数向量用 `'` 会取共轭，纯转置用 `.'`
4. `polyfit` 系数降幂，和设计矩阵 `[1 X X² …]` 求出的 w 顺序相反
5. 题目指定 QR 就写 `[Q,R] = qr(A,0); w = R\(Q'*y)`，不要直接 `A\y`
6. `makedist('Exponential','mu',…)` 的 mu 是**均值 1/λ**
7. Poisson 的 λ 要乘时间窗口长度
8. `var` 默认除以 N−1
9. `fzero` 括号两端必须异号；间断点也会被当成零点 → 先画图
10. 多维 Newton 写 `x = x - J\F`，不是 `F/J`
11. `dsolve` 二阶初值要先 `Dy = diff(y,t)` 再写 `Dy(0) == …`
12. `ode45` 的初值长度 = 状态个数；输出 Y 每一**列**是一个状态
13. 矩阵指数用 `expm`，不是 `exp`
14. `subs(G, s, 1j*w)` 之后要 `abs` / `angle` 才能作图
15. 作图：`hold on`、scatter 画数据、title / xlabel / ylabel / legend 一个都不能少
16. 🎯 差商 Newton：Δx 太大斜率不准，太小被舍入误差淹没；先拿 x² − 2 这种光滑函数测代码，循环要有 `maxIter` 和收敛标志
17. 🎯 `[v1, v2] = dsolve(...)` 会把符号函数 `v1(t)` 覆盖成解；`S = dsolve(...)` 再取 `S.v1`、`S.v2` 更稳
18. 🎯 题目给了输出时刻（如 `tYears = 0:0.05:100`）就把这个向量直接传给 `ode45`；`symsum` 的求和变量要先 `syms`

### C. 进度清单

**Part 0**　☐ 0a　☐ 0b　☐ 0c
**Part T** 🎯　☐ T1　☐ T2　☐ T3　☐ T4　☐ T5
**Part A**　☐ A1　☐ A2　☐ A3　☐ A4　☐ A5　☐ A6a　☐ A6b　☐ A7　☐ A8
**Part B**　☐ B1　☐ B2　☐ B3　☐ B4a　☐ **B4b（原题）**　☐ B4c　☐ B5　☐ B6
**Part C**　☐ C1　☐ C2　☐ C3a　☐ C3b　☐ C3c
**Part D**　☐ D1　☐ D2　☐ D3　☐ D4　☐ D5　☐ D6
**Part E**　☐ E1　☐ E2a　☐ E2b　☐ E3　☐ E4　☐ E5a　☐ E5b　☐ E5c
**Part F**　☐ F1a　☐ F1b　☐ F2a　☐ F2b　☐ F3　☐ F4　☐ F4b
**Part G**　☐ G1　☐ G2a　☐ G2b　☐ G3　☐ G4　☐ G5a　☐ G5b
**Part H**　☐ H1　☐ H2　☐ H3　☐ H4　☐ H5a　☐ H5b　☐ H6a　☐ H6b　☐ H7
**Part I**　☐ I1　☐ I2a　☐ I2b　☐ I3　☐ I4　☐ I5
**Part J**　☐ J1　☐ J2　☐ J3　☐ J4　☐ J5　☐ J6　☐ J7　☐ J8
**Part K**　☐ Mock 1　☐ Mock 2　☐ Mock 3

**最低 70% 路线**（只做这些）：**0a 0b 0c** · **T1 T2 T3 T4 T5** · A1 A2 A5 A6a A8 · B2 B4a B4b · C3a C3b · D4 · E2a E3 **E4** E5a · F2a F2b F3 · G2a G4 G5a · H3 H4 H6a H6b · I2a I4 I5 · J2 J3 J5 J6 J7 · Mock 1
