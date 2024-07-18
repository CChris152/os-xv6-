#include "../kernel/types.h"
#include "../kernel/stat.h"
#include "user.h"

//将数组的第一个数进行打印（素数），然后将其倍数去除，将剩下的数字传到下一个进程

void primes(int *input, int count)
{
  if (count == 0) {
    return;
  }
  int p[2], i = 0, prime = *input;
  pipe(p);
  char buff[4];
  printf("prime %d\n", prime);
  if (fork() == 0) {
	  close(p[0]);
	  for (; i < count; i++) {
	    write(p[1], (char *)(input + i), 2);
	  }
	  close(p[1]);
	  exit(0);
  } else {
	  close(p[1]);
	  count = 0;
	  while (read(p[0], buff, 2) != 0) {
	    int temp = *((int *)buff);
	    if (temp % prime) {
	      *input++ = temp;
		    count++;
	    }
	  }
	  primes(input - count, count);
	  close(p[0]);
	  wait(0);
  }
}

int main(int argc, char *argv[]) {
  int input[34], i = 0;
  for (; i < 34; i++) {
    input[i] = i + 2;
  }
  primes(input, 34);
  exit(0);
}