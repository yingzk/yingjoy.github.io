---
title: 机器学习实战——训练你的 Flappy Pikachu
date: 2017-06-19 16:25:03
en_title: Flappy Pikachu
tags: [Machine Learning]
---

# 前言

皮卡丘又回来啦，由于上一周有些事情要处理，就没有写文章，真的很对不起大家。:(

不过这次笔者给大家带来了一个非常好玩的东西

看标题——机器学习实战——训练你的FlappyPikachu(皮卡丘)

![](https://blog-10039692.file.myqcloud.com/1496513996832_5531_1496514018583.jpg)

那现在我们就开始让我们的皮卡丘变得越来越聪明吧！

##所有密码均为:yjoy

# 正文

在这里我们运用到的是一个名为神经演化（Neuroevolution）的算法。该算法的原理简单说就是通过不断地学习迭代，总结失败和成功，最终使机器变得越来越聪明。

![](https://blog-10039692.file.myqcloud.com/1496514394443_7803_1496514416812.png)

[这里](http://www.scholarpedia.org/article/Neuroevolution)是它相关的介绍

首先，我们先写一个FlappyPikachu的小游戏（代码网上一大堆）

[这是](http://pan.baidu.com/s/1bpgXJYn)笔者的游戏代码

# 开始学习

首先设置一些参数

```javascript
        network:[1, [1], 1],    //神经网络的结构
        population:50,          //第一代数量
        elitism:0.2,            //后代的优秀率
        randomBehaviour:0.2,    //下一代的随机行为率
        mutationRate:0.1,       //突变率
        mutationRange:0.5,      //突变范围
        historic:0,             //最后一代
        lowHistoric:false,      //历史最低？
        scoreSort:-1,           //如何排序
        nbChild:1               //育种数
```

创建各种对象
神经元、神经网络层、神经网络等等
然后输入第一代，通过训练得到下一代

```javascript
//创建第一代
    Generations.prototype.firstGeneration = function(input, hiddens, output){
        var out = [];
        for(var i = 0; i < self.options.population; i++){
            var nn = new Network();
            nn.perceptronGeneration(self.options.network[0],
                        self.options.network[1],
                                          self.options.network[2]);
            out.push(nn.getSave());
        }

        this.generations.push(new Generation());
        return out;
    }
    //YingJoy
```

```javascript
//创建下一代
    Generations.prototype.nextGeneration = function(){
        if(this.generations.length == 0){
            return false;
        }

        var gen = this.generations[this.generations.length - 1]
                .generateNextGeneration();
        this.generations.push(new Generation());
        return gen;
    }
    //YingJoy
```

```javascript
//添加基因信息到代中
    Generation.prototype.addGenome = function(genome){
        for(var i = 0; i < this.genomes.length; i++){
            if(self.options.scoreSort < 0){
                if(genome.score > this.genomes[i].score){
                    break;
                }
            }else{
                if(genome.score < this.genomes[i].score){
                    break;
                }
            }

        }
        this.genomes.splice(i, 0, genome);
    }
    //YingJoy
```

这是第一代皮卡丘，还没出门就撞水管了

![](https://blog-10039692.file.myqcloud.com/1496517635907_8998_1496517657825.png)

然后通过一代又一代的迭代，我们得到的皮卡丘越来越聪明

开始训练时有许多皮卡丘，最后有1只最聪明的，下面是训练了28代得到的皮卡丘，基本保持不死了

![](https://blog-10039692.file.myqcloud.com/1496517602758_2007_1496517624742.png)

这是一个[示例](https://www.qcloud.com/community/article/www.yingjoy.cn)，读者可以来体验一下，下面的按钮是改变运行速度

[这是](http://pan.baidu.com/s/1nvC13Dn)上面示例的代码（JS）

好了，到这里我们就得到了一只越来越聪明的皮卡丘啦。:)