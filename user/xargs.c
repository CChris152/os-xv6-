#include "../kernel/types.h"
#include "user.h"
#include "../kernel/param.h"

int main(int argc, char *argv[]) {
  int i, count = 0, k, m = 0;
  char* line_split[MAXARG], *p;
  char block[32], buf[32];
  p = buf;
  //将argv中的数据（第二个命令）提取出来
  for (i = 1; i < argc; i++) {
	  line_split[count++] = argv[i];
  }
  //将第一个命令的输出读到block中，遍历block，遇到\n时直接分支一个子进程，将block中\n之前的命令作为参数加入到第二个命令中运行，父进程等待后继续执行
  while ((k = read(0, block, sizeof(block))) > 0) {
    for (i = 0; i < k; i++) {
	    if (block[i] == '\n') {
		    buf[m] = 0;
		    line_split[count++] = p;
		    line_split[count] = 0;
		    m = 0;
		    p = buf;
		    count = argc - 1;
        //子进程运行命令
		    if (fork() == 0) {
		      exec(argv[1], line_split);
		    }
		    wait(0);
	    } else if (block[i] == ' ') {
		    buf[m++] = 0;
		    line_split[count++] = p;
		    p = &buf[m];
	    } else {
		    buf[m++] = block[i];
	    }
	  }
  }
  exit(0);
}