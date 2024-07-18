#include "../kernel/types.h"
#include "../kernel/stat.h"
#include "user.h"
#include "../kernel/fs.h"

void find(char *path, char *filename)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  //先判断是否能打开路径
  if ((fd = open(path, 0)) < 0)
  {
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }
  //st中储存路径中的文件/文件夹
  if (fstat(fd, &st) < 0)
  {
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }
  //如果路径直接为文件
  if (st.type == T_FILE)
  {
    fprintf(2, "find: can't find files in a file\n");
    exit(1);
  }
  //路径太长终止
  if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
  {
    printf("find: path too long\n");
    exit(1);
  }
  strcpy(buf, path);
  p = buf + strlen(buf);
  *p++ = '/';
  while (read(fd, &de, sizeof(de)) == sizeof(de))
  {
    if (de.inum == 0)
      continue;
    memmove(p, de.name, DIRSIZ);
    p[DIRSIZ] = 0;
    //路径打不开时
    if (stat(buf, &st) < 0)
    {
      fprintf(2, "find: cannot stat %s\n", buf);
      continue;
    }
    //为文件夹且p不为..或.时继续向下查询，为文件且文件名符合时直接打印
    if (st.type == T_DIR && strcmp(".", p) != 0 && strcmp("..", p) != 0)
      find(buf, filename); // recursion
    else if (st.type == T_FILE && strcmp(p, filename) == 0)
      printf("%s\n", buf); // print the output
  }
  close(fd);
}

int main(int argc, char *argv[])
{
  if (argc < 2)
  {
    fprintf(2, "too little arguments..\n");
    exit(1);
  }
  find(argv[1], argv[2]);
  exit(0);
}