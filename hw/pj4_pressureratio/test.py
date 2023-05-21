verilog_file = 'example.v'
additional_code = """
module AnotherModule(input x, output z);
  assign z = ~x;
endmodule
"""

# 기존 파일 내용 읽기
with open(verilog_file, 'r') as file:
    existing_code = file.read()

# 기존 내용과 추가 내용 합치기
updated_code = existing_code + additional_code

# 새로운 파일에 내용 작성
with open('updated_example.v', 'w') as file:
    file.write(updated_code)


