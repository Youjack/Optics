# Optics

Optics 的目标是使用科学计算语言，为普通物理光学课程制作可视化材料。

Optics 现在包含了以下四个可视化材料
* Beat & Standing Wave (拍与驻波)
* Fraunhofer Diffraction (夫琅禾费衍射)
* Fresnel Equations (菲涅尔公式)
* Polarized Light (偏振光)

Optics 目前使用的科学计算语言包括了 Python，MATLAB，Julia，Wolfram Language。下面简单介绍了这些科学计算语言，以及这些可视化材料的使用。这些材料的演示可在[知乎](https://zhuanlan.zhihu.com/p/342109199)上查看。

## Python

文件夹 Python 下的 `.ipynb` 文件是在 Jupyter 里用 Python 编写的可视化材料。[Jupyter](https://jupyter.org/) 是一个网页应用，可以用于创建包含实时代码，公式，及描述性文本的文档。这种文档被称为 notebook。Jupyter 可以通过 pip 安装。

## MATLAB

## Julia

[Julia](https://julialang.org/) 是一门新兴的科学计算语言，其目标是在科学计算领域成为 C/C++，FORTRAN，Python，MATLAB，R 的替代品，其特点是同时具有 Python 的易用性和 C 的速度。

文件夹 Julia 下的 `.jl` 文件是在 Pluto 里用 Julia 编写的可视化材料。[Pluto](https://github.com/fonsp/Pluto.jl) 是一个用 Julia 编写的类似于 Jupyter 的 notebook 环境。这些文件可以直接使用 Julia 运行，也可以安装 Pluto 和 PlutoUI 后在 Pluto 中运行。

## Wolfram Language

Wolfram Language 是脱胎于 Mathematica 的符号计算语言。Mathematica 价格昂贵，但 Wolfram Research 已经推出了免费的 [Wolfram Engine](https://www.wolfram.com/engine/)。Wolfram Engine 可以使用 Wolfram Language 的所有功能，但缺少 Mathematica 的笔记本界面，但 Jupyter 和免费的 Wolfram Player 可以提供类似的功能。

文件夹 Wolfram Language 下的 `.ipynb` 文件是在 Jupyter 里用 Wolfram Language 编写的可视化材料。要运行这些材料，需要安装 Wolfram Engine 和 [WolframLangugeForJupyter](https://github.com/WolframResearch/WolframLanguageForJupyter)。Jupyter 暂时不能为 Wolfram Language 提供如"拖动滑块改变参数"的交互功能，但这些材料运行后可以生成 `.cdf` 文件，这些文件提供了交互功能，可以用 Mathematica 或 Wolfram Player 打开。(GitHub 可以预览 `.ipynb` 文件，如果不想使用 Jupyter，可以在 GitHub 中查看代码)