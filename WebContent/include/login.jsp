<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<script type="text/javascript">
	//로그인창 열기
	$(function() {
		$(".letterBtn").click(
				function() {
					var W = 600;
					var H = 500;

					// 팝업을 가운데 위치시키기 위해 아래와 같이 값 구하기
					var L = Math.ceil((window.screen.width - W) / 2);
					var T = Math.ceil((window.screen.width - H) / 2);

					window.open("${contextPath}/member/letterPage.do", "쪽지함",
							'width=' + W + ', height=' + H + ', left=' + L
									+ ', top=' + T + ' scrollbars=no')
				});

		$("a.loginBtn").click(function() {
			$(".loginPopup").css("display", "block");
		});

		$("a.close").click(function() {
			$(".loginPopup").css("display", "");
		});

		$("#LoginId").val(Cookies.get('rememberId'));
		if ($("#LoginId").val() != "")
			$("#idRemember").attr("checked", true);

		var modal = document.getElementsByClassName("loginPopup")[0];

		window.onclick = function(event) {
			if (event.target == modal) {
				modal.style.display = "none";
			}
		}

		$("#loginSub").click(function() {

			var id = $("#LoginId").val();
			var pw = $("#LoginPw").val()
			$.ajax({
				type : "post",
				url : "${contextPath}/member/login.do",
				data : ({
					id : id,
					pw : pw
				}),
				dataType : "text",
				success : function(result) {
					if (result == -1) { // 아이디가 등록되어 있지 않은 경우
						alert('로그인에 실패하였습니다.아이디와 비밀번호를 확인해주세요');
					} else if (result == 0) { // 탈퇴한 회원입니다.
						alert('탈퇴한 회원입니다.');
					} else if (result == 1) {// 모두 맞는 경우 => login 성공
						alert(id + '님 반갑습니다.');
						location.reload();
						if ($("#idRemember").is(":checked")) {
							Cookies.set('rememberId', id, {
								expires : 180
							});
						}
					}
				}
			});
		});
	});
</script>

<!--   ##########################로그인 박스###################################################################### -->
<div class="clear"></div>

<div class="loginPopup">
	<div class="loginSpace">
		<a class="close fl_right cursorPointer" id="close">닫기 <i class="fas fa-times"></i></a>
		<form>
			<label class="memberId bold" for="memberId">아이디</label>
			<input type="text" class="memberId" id="LoginId" name="id" placeholder="아이디를 입력하세요">

			<label class="memberPw  bold" for="memberPw">비밀번호</label>
			<input type="password" class="memberPw" id="LoginPw" name="pw" placeholder="비밀번호를 입력하세요" autocomplete="off">

			<div class="fl_left bold rememberBox">
				<label class="memberIdRemember inline" for="idRemember">아이디 저장</label>
				<input type="checkbox" id="idRemember" value="remember" class="inline">
			</div>
			<button type="button" id="loginSub" class="loginSubmit fl_right">로그인</button>

			<div id="search" class="inline clear">
				<a href="${contextPath}/member/findInfo.do">아이디 찾기</a>
				&nbsp;|&nbsp;
				<a href="${contextPath}/member/findInfo.do">비밀번호 찾기</a>
			</div>
		</form>
	</div>
</div>