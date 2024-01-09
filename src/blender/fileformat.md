
# structure

1. header: 12字节： BLENDER + 指针大小1 + 大小端1 + 版本号(3)
2. file-block: header + data // 通用
   1. header： 类型，数据总长度，内存地址，SDNA索引，SDNA索引数量
3. file-block : struct dna
   1. header('DNA1')
   2. Data('SDNA')
      1. Names('NAME'): 固定命名4+长度+具体内容，记录所有的变量和函数
      2. Types('TYPE')： 所有的类型，顺序和TLEN相同
      3. Lengths('TLEN')： 所有变相占用的字节数量
      4. Structures('STRC')： 固定命名4+长度4+具体内容([index in types 2 + index in types 2]*)
4. file-block 'ENDB'