 #### **打包**
 `docker build . -t p_collect`
 ####  **测试运行**
 `docker run -it p_collect `  
 ####  **打iox包**
 `ioxclient docker package p_collect:latest .`
