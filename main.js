const { exec } = require("child_process");

function compress(input, output) {
  // 定义命令行参数
  const command = output
    ? `./main_unix ${input} ${output}`
    : `./main_unix ${input}`;
  // 执行命令
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`执行时出现错误： ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`错误输出： ${stderr}`);
      return;
    }
    console.log(`执行结果： ${stdout}`);
  });
}

module.exports = compress;
