---
title: MIPS-CPU Design Note
excerpt: Learning note.
toc: true
author: xeonds
date: 2023-04-02 19:00:34
---

## 架构分析

总体分为两个：`存储器RAM`和`CPU`

### RAM

MIPS 架构是指令数据分离的模式。即：DMEM和IMEM两个独立存储器，这样的模式下，处理机和IMEM,DMEM需要分别有两条bus来通信。

优点就是数据、指令的长度可以不一样。缺点是系统复杂性的提升，以及空间利用率更低。

### CPU

数据通路和控制部件。

#### 数据通路

- 程序计数器
- NPC: PC=PC+1
- ALU
- RegFile：32个32位存储器
- 位扩展：有/无符号扩展
- 位拼接
- 独立加法器ADD
- 选择器：MUX

#### 控制部件

## 指令设计

一共8条，指令长度为32位。

- ADDU rd, rs, rt：加法指令，将rs，rt的值相加，存储到rd中
- SUBU rd, rs, rt：减法指令，将rs，rt的值相减，存储到rd中
- SLL rd, rt, sa：移位并存储值
- ORI rt, rs, imm16：按位或
- LW rt, offset(base)：根据偏移，加载数据到存储器
- SW rt, offset(base)：存储指令
- BEQ rs, rt, offset：比较并跳转
- J target：无条件跳转指令

MIPS指令分为3类：

|type| -31- format(bits)|
|:-:|:-|
|R|opcode(6), rs(5), rt(5), rd(5), shamt(5), funct(6)|
|I|opcode(6), rs(5), rt(5), immediate(16)|
|J|opcode(6), address(26)|

