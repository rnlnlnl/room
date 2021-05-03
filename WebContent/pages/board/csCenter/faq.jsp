<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
.accordion {
  border-radius: 10px 0 0 0;
  cursor: pointer;
  padding: 18px;
  width: 100%;
  border-top: 1px solid #572e17 ;
  text-align: left;
  outline: none;
  font-size: 15px;
  transition: 0.4s;
  background-color: #98644d;

}

.content .active, .accordion:hover {
 	border-top: 2px solid #fb4f02;
    background-color: #da7c52;
	color: none;
}

.panel {
  padding: 0 18px;
  display: none;
  background-color: white;
  overflow: hidden;
}
.center{
	margin: 0 11%;
    padding: 2% 6%;
}

. accoCor{
	background-color: #98644d;
	color: #9c4d29 !important;
}
    
</style>
</head>
<body>

<h2 class="noticeTitle">bestQnA</h2>
<div class="hoc container1 clear">
<div class="content">
<button class="accordion accoCor">판매자에게 연락하고 싶어요</button>
<div class="panel">
<p>
√ 상품 상세페이지 또는 전체주문내역에서 미니샵명 클릭 시 판매자 연락처 확인 가능

판매자와 전화연결이 되지 않는다면 상품 상세페이지에서 판매자에게 문의하기로 글을 남겨 주세요.

아래에 판매자에게 문의하기 방법 상세하게 표시되어있음(이미지 파일등)
<img alt="#" src="#">

</p>
</div>
<button class="accordion accoCor">판매자에게 연락하고 싶어요</button>
<div class="panel">
<p>
√ 상품 상세페이지 또는 전체주문내역에서 미니샵명 클릭 시 판매자 연락처 확인 가능

판매자와 전화연결이 되지 않는다면 상품 상세페이지에서 판매자에게 문의하기로 글을 남겨 주세요.

아래에 판매자에게 문의하기 방법 상세하게 표시되어있음(이미지 파일등)
<img alt="#" src="#">

</p>
</div>

<button class="accordion accoCor">판매자에게 연락하고 싶어요</button>
<div class="panel">
<p>
√ 상품 상세페이지 또는 전체주문내역에서 미니샵명 클릭 시 판매자 연락처 확인 가능

판매자와 전화연결이 되지 않는다면 상품 상세페이지에서 판매자에게 문의하기로 글을 남겨 주세요.

아래에 판매자에게 문의하기 방법 상세하게 표시되어있음(이미지 파일등)
<img alt="#" src="#">

</p>
</div>

<button class="accordion accoCor">판매자에게 연락하고 싶어요</button>
<div class="panel">
<p>
√ 상품 상세페이지 또는 전체주문내역에서 미니샵명 클릭 시 판매자 연락처 확인 가능

판매자와 전화연결이 되지 않는다면 상품 상세페이지에서 판매자에게 문의하기로 글을 남겨 주세요.

아래에 판매자에게 문의하기 방법 상세하게 표시되어있음(이미지 파일등)
<img alt="#" src="#">

</p>
</div>
</div>
</div>
<script>
var acc = document.getElementsByClassName("accordion");
var i;

for (i = 0; i < acc.length; i++) {
  acc[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var panel = this.nextElementSibling;
    if (panel.style.display === "block") {
      panel.style.display = "none";
    } else {
      panel.style.display = "block";
    }
  });
}
</script>

</body>
</html>
