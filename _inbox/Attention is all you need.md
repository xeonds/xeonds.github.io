---
title: Attention is all you need
date: 2024-06-10 14:22:28
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---
# 注意力满足一切

Ashish Vaswani Google Brain avaswani@google.com  
Noam Shazeer Google Brain noam@google.com  
Niki Parmar Google Research nikip@google.com  
Jakob Uszkoreit Google Research usz@google.com  
Llion Jones Google Research llion@google.com  
Aidan N. Gomez University of Toronto aidan@cs.toronto.edu  
Łukasz Kaiser Google Brain lukaszkaiser@google.com  
Illia Polosukhin illia.polosukhin@gmail.com

## 摘要

主流序列转换模型都是基于复杂的包含一个编码器和一个解码器的循环或卷积神经网络。最佳的性能模型也是借助注意力机制将编码器和解码器连接一起做到的。本文提出一种新型简单网络架构Transformer，只依赖注意力机制，完全摒弃了递归和卷积。对双机翻译任务的实验表明，这种模型有更加优良的品质，还支持并行化，需要的训练时间显著减少。在WMT2014英德翻译任务上达到了28.4 BLEU，比现有最佳结果提升了2BLEU以上。在WMT2014英法翻译任务上，我们成功创建了一个新的单模型，在8GPU上训练3.5天就达到了41.8 BLEU的SOTA得分，这是目前最好模型训练成本的很小比例。本文还表明，Transformer同样可以很好的泛化到其他任务。

## 一、介绍

RNN（循环神经网络），LSTM[13]，尤其是GRU（门控循环神经网络）[7]已经稳定地成为序列建模和转换问题领域（如语言建模、机器翻译[35, 2, 5]）的最佳方法。大量的工作在不断努力拓展循环语言模型和编码器-解码器架构[38, 24, 14]的能力边界。  
循环模型通常沿输入和输出序列的符号位置进行计算，将位置与计算时间的步骤对齐后，将先前隐状态 ht−1和位置 t作为输入，生成一系列新的隐状态ht。这种固有的序列性本质限制了训练样本的并行化，对更长的序列这个问题尤其严重，因为多个样本之间内存限制了批处理。近来一些工作通过分解技巧[21]和条件计算[32]显著提高了计算效率，而且条件计算还提高了模型性能。但序列计算的根本性约束依然存在。  
注意力机制已成为各种序列建模和转导模型任务最引人注目的组件，它支持对依赖项进行建模，而无需考虑它们在输入或输出序列中的距离[2, 19]。然而，在全部但很少的情况下[27]，这种注意力机制被用来与循环网络结合使用。  
本作中，我们提出的Transfomer是一种规避循环的模型架构，完全依赖注意力机制来绘制输入和输出之间的全局依赖关系。在8个P100 GPU上经过短短12小时的训练后，Transformer就实现了更多的并行化，并在翻译质量方面达到了新水平。

## 二、背景

减少序列型计算的目标也造就了扩展神经GPU[16]、ByteNet[18]和ConvS2S[9]的基石，他们使用卷及神经网络作为基础构建模块，对对所有输入和输出位置并行计算隐式表征。这些模型中，关联来自两个任意输入或输出位置的信号所需的操作数量随着位置之间的距离而增长，对于 ConvS2S 呈线性增长，而对于 ByteNet 则呈对数增长。这给学习长距离位置关系间的依赖造成了更多的困难[12]。在Transformer中，这个数量被消减到常数值，尽管由于平均注意力加权位置而降低了有效分辨率，我们使用了多头注意力来抵消这种影响，见3.2节。自注意力，有时也叫内部注意力，是一种将单个序列中不同位置关联起来以计算序列表征的一种注意力机制。自注意力已成功应用在各种任务中，包括阅读理解、抽象摘要、文本蕴含和学习任务无关的句子表征[4, 27, 28, 22]。端到端记忆网络在基于循环注意机制而不是序列对齐循环时，被证明在简单语言问答和语言建模任务中表现较好[34]。据我们所知，Transformer还是第一个完全依赖自注意力来计算其输入和输出表示而不使用序列对齐RNN或卷积的转换模型。接下来，我们将详细介绍Transformer，使用自注意力的动机，并讨论其相对于 [17、18] 和 [9] 等模型的优势。

## 三、模型架构

大部分有竞争力的神经序列转换模型都具有编码器-解码器结构[5, 2, 35]。这里，编码器将一组基于符号表示的输入序列$(x_1,…,x_n)$映射到连续表示的序列$z=(z_1,…,z_n)$。给定$z$ ，解码器再产生一个输出序列$(y_1,…,y_m)$。每个步骤中，模型都是自回归的[10]，即将之前生成的序列作为输入来生成下一个符号。Transformer也遵循这个整体架构，对编码器和解码器使用堆叠自注意力和逐点全连接层，分别如图1的左半部分和右半部分所示。

![](http://www.dengfanxin.cn/wp-content/uploads/2022/08/image-832x1024.png)

### 3.1 编码器和解码器栈

编码器：编码器由$N=6$个相同层的栈构成。每层有两个子层。第一个子层为多头自注意力机制，第二个是简单的逐点全连接前馈网络。在两个子层之间使用残差连接[11]，接着进行层归一化(Layer Normalization)[1]，即每个子层的输出为$LayerNorm(x+Sublayer(x))$，其中Sublayer(x)是子层本身所实现的函数。为了利用上这些残差连接，所有模型中的子层包括嵌入层都产出维度$dmodel=512$的输出。解码器：解码器也由N=6个相同层的栈构成。在编码层的两个子层之外，解码层又插入了第三个子层，用作在编码器栈的输出应用多头注意力。类似于编码器，每个子层使用了残差连接，再做层归一化。我们还修改了解码栈中的自注意力子层以防止位置可以注意到后续的位置，即结合“输出嵌入偏移一个位置”这样一个事实， 使用掩码来确保对位置i的预测只能依赖于位置小于i的已知输出。

解码器：解码器也由N=6个相同层的栈构成。在编码层的两个子层之外，解码层又插入了第三个子层，用作在编码器栈的输出应用多头注意力。类似于编码器，每个子层使用了残差连接，再做层归一化。我们还修改了解码栈中的自注意力子层以防止位置可以注意到后续的位置，即结合“输出嵌入偏移一个位置”这样一个事实， 使用掩码来确保对位置i的预测只能依赖于位置小于i的已知输出。

### 3.2 注意力

注意力函数可以描述成将查询query和一组Key-value对儿映射到一个输出output上，其中query、keys、values和ouput都是向量。output被计算成值的加权求和，而值对应的加权值由query和其对应key的兼容性函数计算得出。

![](http://www.dengfanxin.cn/wp-content/uploads/2022/08/image-1-1024x578.png)

#### 3.2.1 缩放点积注意力

我们的特殊注意力命名为“缩放点积注意力”（见图2）。输入由queries、dk个维度的keys和dv个维度的values构成，然后用所有的keys来算每个query的点积，再分别除以dk‾‾√，再应用softmax函数以获得值values的权重。实践中，我们是在一组queries上并行计算注意力函数的，然后再打包在一起放入矩阵Q中，同理，keys和values也打包在分别装入矩阵K和V中。这样计算的输出矩阵就是：
$$
Attention(Q,K,V)=softmax(QKTdk√)V
$$
两个使用最多的注意力函数是加法注意力[2]和点积注意力。点积注意力的算法与我们的相同，唯一区别是缩放系数dk‾‾√；加法注意力则使用带一个隐藏层的前馈网络计算兼容函数(compatibility function)。虽然两者在在理论复杂度上比较接近，点积注意力却因为可以利用高度优化的矩阵乘法代码而速度更快、更省空间。当dk较小时，两种机制表现相当，而在没有使用较大的dk时，加法注意力反而要优于点积注意力[3]。我们怀疑对于较大的dk，点积结果会变得很大，将 softmax 函数推入到具有极小梯度的区域（为了说明点积变大的原因，假设q和k的分别是均值为0，方差为1的独立随机变量，那么他们的点积$q·k=∑dki=1q_ik_i$也是均值为0，方差为dk）。为了抵消这种影响，我们将点积使用dk‾‾√缩放一下。  

#### 3.2.2 多头注意力

相比对dmodel维的keys、values和queries执行单注意力函数，我们发现使用不同、习得的线性映射分别映射到dk、dk和dv维h遍，会更加有用。对queries、keys和values的映射后的版本再并行执行注意力函数产生dv维的输出值，再将这些值拼接（concatenate）起来，再做一次线性映射产出最终的结果值，参见图2。  
多头注意力让模型可以联合关注到来自不同位置不同表征空间的信息。如果只有一个注意力头，值平均会抑制这些信息。  
$MultiHead(Q,K,V)=Concat(head1,…,headh)W_O$ 
其中，  
$$
head_i=Attention(QWQi,KWKi,VWiV)  
$$
其中，映射就是参数矩阵WQi∈ℝdmodel×dk，WKi∈ℝdmodel×dk，WVi∈ℝdmodel×dv和WOi∈ℝhdv×dmodel。  
本次工作中，我们使用了h=8 的并行注意力层（也就是头head）。每个dk=dv=dmodel/h=64由于每个头都消减了维度，最后的总计算成本和带全维度的单注意力头差不多。  

#### 3.2.3 模型中注意力的应用

Transformer以三种方式使用了多头注意力：

- 在“编码器-解码器”层中，queries来自与之前的解码层，记忆keys和values来自于编码器的输出。这使得解码器的每个位置都能关注到输入序列的所有位置。这模仿了sequence-to-sequence模型[38, 2, 9]中的典型的编码器-解码器机制。
- 编码器包含自注意力层。自注意力层的keys、values和queries全部都来自同一个地方，即编码器中前一层的输出。编码器中的每个位置都能关注到编码器前一层的所有位置。
- 类似地，解码器的自注意力层允许解码器的每个位置都能关注到解码器中的所有位置。我们需要防止解码器中的信息向左流动以保持自回归特性。我们通过在缩放点积注意力的内部遮盖掉（设置为 -∞）与非法连接相对应的softmax的 输入中的所有值来实现这一点。参见图2。

### 3.3 逐位前馈网络

除了注意力子层，编码器和解码器的每一层还包含一个全连接前馈网络，它会对每个位置都会相同地、独立地应用一遍，它包括两个线性变换，中间有一个ReLU激活函数。

$$
FFN(x)=max(0,xW_1+b_1)W_2+b_2
$$

线性转换在所有的位置上都是一样的，但他们在层与层之间使用不同的参数。另一种描述的方式是kernel size为1的两个卷积。输入和输出的维度是$dmodel=512$，内层的维度为$dff=2048$。  

### 3.4 embedding和softmax

跟其他序列转换模型类似，我们使用学习到的embeddings将输入tokens和输出tokens转换成dmodel维的向量。我们也使用通常学习到的线性变换和softmax函数将解码器的输出转换为预测的下一个token的概率。模型的两个embedding层和前置softmax线性转换采用权重共享矩阵，类似于[30]。在embedding层，使用dmodel‾‾‾‾‾‾√乘以这些权重。

![](http://www.dengfanxin.cn/wp-content/uploads/2022/08/image-2-1024x328.png)

### 3.5 位置编码

既然我们的模型不再使用循环和卷积，为了让模型能利用上序列的顺序，我们必须要注入一些与token在序列中的相对和绝对位置相关的信息。为此，我们在编码和解码栈底部的输入embedding中增加了“位置编码”，位置编码与嵌入具有相同的维度dmodel，因此可以将两者相加。位置编码有很多方案选择，学习的和固定的[9]。  
本工作中，我们使用不同频率的正弦和余弦函数：  
PE(pos,2i)=sin(pos/10002i/dmodel)  
PE(pos,2i+1)=cos(pos/10002i/dmodel)  
其中pos是位置，i是维度。也就是，位置编码的每个维度都对应一个正弦曲线。波长形成从2π到10000·2π的几何级数。我们选择这个函数是因为我们假定模型可以很容易依赖相对位置来学会注意力，因为对于任何固定的偏移量k，PEpos+k可以用PEpos的线性函数来表征。我们还尝试了使用学习的位置嵌入[0]，发现这两个版本效果基本相同（见表3行（E））。我们最终选择正弦版本，是因为他可以让模型推断出比训练期间遇到的序列更长的序列。我们还尝试使用学习的位置嵌入 [9]，发现这两个版本产生了几乎相同的结果。 我们选择了正弦版本，因为它可以让模型推断出比训练期间遇到的序列长度更长的序列长度。

## 4. 为什么选择自注意力

本节我们将从各个方面将自注意力层与循环和卷积层进行比较，这些循环和卷积层通常用于将一个可变长的符号表示序列(x1,…,xn)映射到另一个等长序列(z1,…,zn)，其中xi,zi∈ℝd，例如典型的序列转换编码器或解码器的隐藏层。我们使用自注意力的动机主要来自于三个方面的考虑。  
一个是每层的总计算复杂度。另一个是计算量可以并行化，一是每层的总计算复杂度。 另一个是可以并行化的计算量可用所需的最小顺序操作数来衡量。  
第三个是网络中远程依赖关系之间的路径长度。 学习长程依赖是许多序列转换任务中的关键挑战。 影响学习这种依赖性的能力的一个关键因素是前向和后向信号必须在网络中遍历的路径长度。  
输入和输出序列中任意位置组合之间的这些路径越短，就越容易学习远程依赖[12]。 因此，我们还比较了由不同层类型组成的网络中任意两个输入和输出位置之间的最大路径长度。如表 1 所示，恒定数量的顺序执行操作自注意力层就可以将所有位置相互连接起来，而循环层则需要 O(n)的顺序操作。在计算复杂度方面，当序列长度n小于表征维度d时，自注意力层比循环层更快，这通常是机器翻译中最先进模型使用的句子表示的情况，例如word-piece [38]和byte-pair [31] 表征法。为了提高涉及非常长序列的任务的计算性能，自注意力可以限制为仅考虑大小为r的邻域。输入序列以各自的输出位置为中心。这会将最大路径长度增加到O(n/r)。我们计划在未来的工作中进一步研究这种方法。  
内核宽度k的单个卷积层不会连接所有输入和输出位置对。这样做需要在连续相同内核（contiguous kernels）的情况下堆叠O(n/k)个卷积层，或者在扩张卷积（dilated convolutions[18]）的情况下需要O(logk(n))，从而在网络中增加了任意两个位置之间的最长路径。卷积层通常比循环层昂贵k倍。然而，可分离卷积（Separable convolutions） [6] 将复杂度大大降低到O(k·n·d+n·d2)。然而，即使k=n，可分离卷积的复杂度也等于自注意力层和逐点前馈层的组合（我们在模型中采用的方法）。  
作为附带的好处，自注意力可以产生更多可解释的模型。我们对模型检查了其注意力分布，并在附录中展示和讨论了相关示例。不仅单个注意力头清楚地学习执行不同的任务，而且许多似乎表现出与句子的句法和语义结构相关的行为。

## 5. 训练

本节介绍我们模型的训练机制。

### 5.1 训练数据和批处理

我们在由大约 450 万个句子对组成的标准WMT2014英德双语翻译数据集上进行了训练。句子使用Byte-Pair 编码[3]进行编码，该编码具有大约37000个标记的共享源-目标词汇表。对于英法翻译，我们使用了更大的 WMT2014英法双语翻译数据集，该数据集由 3600 万个句子组成，并将tokens拆分为32000个单词词汇表[38]。句子对按相近的序列长度进行批次分组。每个训练批次包含一组句子对，其中包含大约25000个源tokens和25000个目标tokens。

### 5.2 硬件和时间

我们在8个NVIDIA P100 GPU上训练模型。整篇论文中模型都使用这些超参数，每个训练步骤大约耗时0.4秒。基础模型训练了10万步或12小时。对于大模型（表3最后一行）每步耗时1秒。大模型训练了30万步（3.5天）。

### 5.3 优化器

我们使用了Adam优化器[20]，参数为β1=0.9，β2=0.98和ϵ1=10−9。随着训练进程，我们使用不同的学习率，遵循以下公式：

![](http://www.dengfanxin.cn/wp-content/uploads/2022/08/image-3-1024x89.png)

相当于在第一个$warmup steps$训练步骤中线性增加学习率，然后根据步数的平方根倒数按比例减少学习率，$warmup steps = 4000$。

### 5.4 正则化

我们在训练过程中采用了三种正则化：  
**Residual Dropout** 我们将dropout [33]应用于每个子层的输出，然后将其添加到子层输入并进行归一化。 此外，我们将dropout应用于编码器和解码器堆栈中嵌入和位置编码的总和。 对于基本模型，我们使用Pdrop=0.1的比率。

**标签平滑** 在训练过程中，我们采用了值为ϵls=0.1[36] 的标签平滑。 这样会增加困惑，因为模型会变得更加不确定，但会提高准确性和 BLEU 分数。

![](http://www.dengfanxin.cn/wp-content/uploads/2022/08/image-4-1024x475.png)

## 6. 结果

### 6.1 机器翻译

在WMT 2014英德翻译任务中，大Transformer 模型（表 2 中的 Transformer (big)）比之前报道的最佳模型（包括集成模型）高出2.0BLEU以上，达到一个全新水平的得分28.4。该模型的配置列于表3的最后一行。在 8 个P100 GPU上训练耗时 3.5 天。甚至我们的基础模型也超过了所有先前发布的模型和集成模型，其训练成本只是任何竞争模型的一小部分。  
在WMT 2014英法翻译任务中，我们的大模型达到41.0的BLEU分数，优于之前发布的所有单一模型，其训练成本不到之前最先进模型的1/4。为英法翻译训练的Transformer（大）模型使用的Dropout是Pdrop=0.1，而不是 0.3。  
对于基本模型，我们使用通过平均最后5个checkpionts获得了单个模型，这些检查点以10分钟的间隔写入。对于大型模型，我们平均了最后20个checkpoints。我们使用集束搜索（beam search），束大小为4，长度惩罚（length penalty）α=0.6 [38]。  
这些超参数是在对开发集上进行实验后选择的，我们将推理期间的最大输出长度设置为输入长度 + 50，但在可能的情况下提前终止[38]。表 2 总结了我们的结果，并将我们的翻译质量和训练成本与文献中的其他模型架构进行了比较。我们通过将训练时间、使用的 GPU 数量以及每个 GPU 5 的持续单精度浮点容量的估计值相乘来估计用于训练模型的浮点运算的数量。

### 6.2 模型变化

为了评估Transformer中不同组件的重要性，我们以不同的方式改变了我们的基础模型，测量了开发集 newstest2013上英德翻译性能的变化。我们使用了上一节中描述的集束搜索，但没有做checkpoints平均。我们在表3中展示了这些结果。

![](http://www.dengfanxin.cn/wp-content/uploads/2022/08/image-5-1024x792.png)  
  
![](http://www.dengfanxin.cn/wp-content/uploads/2022/08/image-6-1024x437.png)

在表3行(A)中，我们改变了注意力头的数量以及注意力键和值维度，保持计算量不变，如第 3.2.2 节所述。 虽然单头注意力比最佳设置差0.9BLEU，但质量也会因为有太多头而下降。  
在表3行(B)中，我们观察到减小注意力key大小dk会损害模型质量。这表明确定兼容性并不容易，比点积更复杂的兼容性功能可能是有益的。我们在行(C)和(D)中进一步观察到，正如预期的那样，更大的模型更好，并且dropout非常有助于避免过度拟合。 在第(E)行中，我们用学习的位置嵌入[9]替换我们的正弦位置编码，并观察到与基础模型几乎相同的结果。

### 6.3 英语成分句法分析（Constituency Parsing）

为了评估Transformer是否可以泛化到其他任务，我们对英语成分句法分析进行了实验。这项任务提出了具体的挑战：输出受到强烈的结构约束，并且明显长于输入。此外，RNN序列到序列模型无法在小数据机制中获得最先进的结果[37]。  
我们在Penn Treebank[25]的华尔街日报(WSJ)部分训练了一个dmodel=1024 的4层转换器，大约 40K训练句子。我们还在半监督环境中对其进行了训练，使用来自大约1700 万个句子的更大的高置信度和 BerkleyParser语料库[37]。我们将16K tokens的词汇表作为WSJ的唯一设置，将32K tokens词汇表用于半监督设置。  
我们只进行了少量实验来选择第 22 节开发集上的dropout、注意力和残差（第 5.4 节）、学习率和束大小，所有其他参数与英德基础翻译模型保持不变。在推理过程中，我们将最大输出长度增加到输入长度 + 300。我们对WSJ和半监督设置都使用了21的束大小和α=0.3。我们在表 4 中的结果表明，尽管缺乏针对特定任务的调整，但我们的模型表现得非常好，比除循环神经网络语法 [8] 之外的所有先前报告的模型都产生了更好的结果。  
与RNN序列到序列模型 [37] 相比，即使仅在WSJ 40K句子的训练集上进行训练，Transformer 也优于 Berkeley-Parser [29]。

## 7. 结论

在这项工作中，我们提出了 Transformer，这是第一个完全基于注意力的序列转换模型，用多头自注意力取代了编码器-解码器架构中最常用的循环层。对于翻译任务，Transformer的训练速度明显快于基于循环或卷积层的架构。在 WMT2014英德和 WMT2014英法翻译任务上，我们都达到了全新的水平。在英德任务中，我们最好的模型甚至优于所有先前报道的集成模型。我们对基于注意力的模型的未来感到兴奋，并计划将它们应用于其他任务。我们计划将Transformer扩展到涉及文本以外的输入和输出模式的问题，并研究局部的受限注意力机制，以有效处理图像、音频和视频等大型输入和输出，让生成模型有更少的顺序性是我们的另一个研究目标。我们用于训练和评估模型的代码可在<https://github.com/tensorflow/tensor2tensor>获得。

**致谢** 感谢Nal Kalchbrenner和Stephan Gouws富有成效的评论、更正和启发。

## 参考文献

[1] Jimmy Lei Ba, Jamie Ryan Kiros, and Geoffrey E Hinton. Layer normalization. arXiv preprint arXiv:1607.06450, 2016.  
[2] Dzmitry Bahdanau, Kyunghyun Cho, and Yoshua Bengio. Neural machine translation by jointly learning to align and translate. CoRR, abs/1409.0473, 2014.  
[3] Denny Britz, Anna Goldie, Minh-Thang Luong, and Quoc V. Le. Massive exploration of neural machine translation architectures. CoRR, abs/1703.03906, 2017.  
[4] Jianpeng Cheng, Li Dong, and Mirella Lapata. Long short-term memory-networks for machine reading. arXiv preprint arXiv:1601.06733, 2016.  
[5] Kyunghyun Cho, Bart van Merrienboer, Caglar Gulcehre, Fethi Bougares, Holger Schwenk, and Yoshua Bengio. Learning phrase representations using rnn encoder-decoder for statistical machine translation. CoRR, abs/1406.1078, 2014.  
[6] Francois Chollet. Xception: Deep learning with depthwise separable convolutions. arXiv preprint arXiv:1610.02357, 2016.  
[7] Junyoung Chung, Çaglar Gülçehre, Kyunghyun Cho, and Yoshua Bengio. Empirical evaluation of gated recurrent neural networks on sequence modeling. CoRR, abs/1412.3555, 2014.  
[8] Chris Dyer, Adhiguna Kuncoro, Miguel Ballesteros, and Noah A. Smith. Recurrent neural network grammars. In Proc. of NAACL, 2016.  
[9] Jonas Gehring, Michael Auli, David Grangier, Denis Yarats, and Yann N. Dauphin. Convolu- tional sequence to sequence learning. arXiv preprint arXiv:1705.03122v2, 2017.  
[10] Alex Graves. Generating sequences with recurrent neural networks. arXiv preprint arXiv:1308.0850, 2013.  
[11] Kaiming He, Xiangyu Zhang, Shaoqing Ren, and Jian Sun. Deep residual learning for im- age recognition. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition, pages 770–778, 2016.  
[12] Sepp Hochreiter, Yoshua Bengio, Paolo Frasconi, and Jürgen Schmidhuber. Gradient flow in recurrent nets: the difficulty of learning long-term dependencies, 2001.  
[13] Sepp Hochreiter and Jürgen Schmidhuber. Long short-term memory. Neural computation, 9(8):1735–1780, 1997.  
[14] Zhongqiang Huang and Mary Harper. Self-training PCFG grammars with latent annotations across languages. In Proceedings of the 2009 Conference on Empirical Methods in Natural Language Processing, pages 832–841. ACL, August 2009.  
[15] Rafal Jozefowicz, Oriol Vinyals, Mike Schuster, Noam Shazeer, and Yonghui Wu. Exploring the limits of language modeling. arXiv preprint arXiv:1602.02410, 2016.  
[16] Łukasz Kaiser and Samy Bengio. Can active memory replace attention? In Advances in Neural Information Processing Systems, (NIPS), 2016.  
[17] Łukasz Kaiser and Ilya Sutskever. Neural GPUs learn algorithms. In International Conference on Learning Representations (ICLR), 2016.  
[18] Nal Kalchbrenner, Lasse Espeholt, Karen Simonyan, Aaron van den Oord, Alex Graves, and Ko- ray Kavukcuoglu. Neural machine translation in linear time. arXiv preprint arXiv:1610.10099v2, 2017.  
[19] Yoon Kim, Carl Denton, Luong Hoang, and Alexander M. Rush. Structured attention networks. In International Conference on Learning Representations, 2017.  
[20] Diederik Kingma and Jimmy Ba. Adam: A method for stochastic optimization. In ICLR, 2015.  
[21] Oleksii Kuchaiev and Boris Ginsburg. Factorization tricks for LSTM networks. arXiv preprint arXiv:1703.10722, 2017.  
[22] Zhouhan Lin, Minwei Feng, Cicero Nogueira dos Santos, Mo Yu, Bing Xiang, Bowen Zhou, and Yoshua Bengio. A structured self-attentive sentence embedding. arXiv preprint arXiv:1703.03130, 2017.  
[23] Minh-Thang Luong, Quoc V. Le, Ilya Sutskever, Oriol Vinyals, and Lukasz Kaiser. Multi-task sequence to sequence learning. arXiv preprint arXiv:1511.06114, 2015.  
[24] Minh-Thang Luong, Hieu Pham, and Christopher D Manning. Effective approaches to attention- based neural machine translation. arXiv preprint arXiv:1508.04025, 2015.  
[25] MitchellPMarcus,MaryAnnMarcinkiewicz,andBeatriceSantorini.Buildingalargeannotated corpus of english: The penn treebank. Computational linguistics, 19(2):313–330, 1993.  
[26] David McClosky, Eugene Charniak, and Mark Johnson. Effective self-training for parsing. In Proceedings of the Human Language Technology Conference of the NAACL, Main Conference, pages 152–159. ACL, June 2006.  
[27] Ankur Parikh, Oscar Täckström, Dipanjan Das, and Jakob Uszkoreit. A decomposable attention model. In Empirical Methods in Natural Language Processing, 2016.  
[28] Romain Paulus, Caiming Xiong, and Richard Socher. A deep reinforced model for abstractive summarization. arXiv preprint arXiv:1705.04304, 2017.  
[29] Slav Petrov, Leon Barrett, Romain Thibaux, and Dan Klein. Learning accurate, compact, and interpretable tree annotation. In Proceedings of the 21st International Conference on Computational Linguistics and 44th Annual Meeting of the ACL, pages 433–440. ACL, July 2006.  
[30] Ofir Press and Lior Wolf. Using the output embedding to improve language models. arXiv preprint arXiv:1608.05859, 2016.  
[31] Rico Sennrich, Barry Haddow, and Alexandra Birch. Neural machine translation of rare words with subword units. arXiv preprint arXiv:1508.07909, 2015.  
[32] Noam Shazeer, Azalia Mirhoseini, Krzysztof Maziarz, Andy Davis, Quoc Le, Geoffrey Hinton, and Jeff Dean. Outrageously large neural networks: The sparsely-gated mixture-of-experts layer. arXiv preprint arXiv:1701.06538, 2017.  
[33] Nitish Srivastava, Geoffrey E Hinton, Alex Krizhevsky, Ilya Sutskever, and Ruslan Salakhutdi- nov. Dropout: a simple way to prevent neural networks from overfitting. Journal of Machine Learning Research, 15(1):1929–1958, 2014.  
[34] Sainbayar Sukhbaatar, Arthur Szlam, Jason Weston, and Rob Fergus. End-to-end memory networks. In C. Cortes, N. D. Lawrence, D. D. Lee, M. Sugiyama, and R. Garnett, editors, Advances in Neural Information Processing Systems 28, pages 2440–2448. Curran Associates, Inc., 2015.  
[35] Ilya Sutskever, Oriol Vinyals, and Quoc VV Le. Sequence to sequence learning with neural networks. In Advances in Neural Information Processing Systems, pages 3104–3112, 2014.  
[36] Christian Szegedy, Vincent Vanhoucke, Sergey Ioffe, Jonathon Shlens, and Zbigniew Wojna. Rethinking the inception architecture for computer vision. CoRR, abs/1512.00567, 2015.  
[37] Vinyals & Kaiser, Koo, Petrov, Sutskever, and Hinton. Grammar as a foreign language. In Advances in Neural Information Processing Systems, 2015.  
[38] Yonghui Wu, Mike Schuster, Zhifeng Chen, Quoc V Le, Mohammad Norouzi, Wolfgang Macherey, Maxim Krikun, Yuan Cao, Qin Gao, Klaus Macherey, et al. Google’s neural machine translation system: Bridging the gap between human and machine translation. arXiv preprint arXiv:1609.08144, 2016.  
[39] Jie Zhou, Ying Cao, Xuguang Wang, Peng Li, and Wei Xu. Deep recurrent models with fast-forward connections for neural machine translation. CoRR, abs/1606.04199, 2016.  
[40] Muhua Zhu, Yue Zhang, Wenliang Chen, Min Zhang, and Jingbo Zhu. Fast and accurate shift-reduce constituent parsing. In Proceedings of the 51st Annual Meeting of the ACL (Volume 1: Long Papers), pages 434–443. ACL, August 2013.
