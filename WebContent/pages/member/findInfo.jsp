<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />


<!-- 사용안하는 페이지 -->

<script type="text/javascript">
	function findId() {

		var name = $("#name").val();
		var email = $("#findIdEmail").val();

		if (email == "") {
			alert("메일주소를 입력하셔야 합니다.");
		} else {
			$
					.ajax({
						type : 'POST',
						url : '${contextPath}/member/findId.do',
						data : {
							name : name,
							email : email
						},
						dataType : "text",
						success : function(id) {
							if (id == "") {
								$('#getId')
										.html(
												"<font color='red'><b>회원 정보가 존재하지 않습니다.</b></font>");
							} else {
								$('#getId').html(
										"<font color='green'><b>찾으시는 아이디는["
												+ id + "] 입니다.</b></font>");
								$("#findIdBtn").css("display", "none");
							}
						},
						error : function(e) {
							alert(e);
						}
					});
		}
	}

	function modRandPw() {
		var id = $("#id").val();
		var email = $("#findPwEmail").val();

		if (id == "") {
			alert("아이디를 입력해주세요");
		}
		if (email == "") {
			alert("메일주소를 입력하셔야 합니다.");
		} else {
			$
					.ajax({
						type : 'POST',
						url : '${contextPath}/member/modRandPw.do',
						data : {
							id : id,
							email : email
						},
						dataType : "text",
						success : function(result) {
							if (result == "true") {
								$('#modPwState')
										.html(
												"<font color='green'><b>회원님의 이메일로 임시 비밀번호가 전송되었습니다.<br>로그인 후 비밀번호 변경 하시길 바랍니다.</b></font>");
							} else {
								$('#modPwState')
										.html(
												"<font color='red'><b>일치하는 회원이 없습니다.</b></font>");
							}
						},
						error : function() {
							alert("ERROR!!");
						}
					});
		}
	}
</script>
<section id="section">
	<div class="row findInfo">
		<h2>아이디 찾기</h2>
		<p>회원님의 이름과 가입시 입력하신 이메일을 입력하여주세요.</p>
	
		<div class="form-group col-xs-9 col-sm-9col-md-9 col-lg-9">
			<label for="name" id="joinFontSize">이름</label>
			<input type="text" name="name" id="name" class="form-control boxSize">
			<br>
		</div>
	
	
		
		<div class="form-group col-xs-9 col-sm-9col-md-9 col-lg-9">
			<label for="findIdEmail" id="joinFontSize">이메일</label> 
			<input type="email" name="email" id="findIdEmail" class="form-control boxSize idPosi" placeholder="aaa123@aaa.com">
		</div>
		<br>
		
		<div class="form-group col-xs-3 col-sm-3 col-md-4 col-lg-3">
			<input type="button" id="findIdBtn" value="아이디 찾기" class="dup btn btn btn-block m-t-md boxSize" onclick="findId()">
			<span id="getId">&nbsp;</span>
			<br>
		</div>
	</div>
	<br> 
	<hr> 
	<br>
	
	
	<div class="row findInfo">
		<h2>비밀번호 찾기</h2>
		<p>회원님의 ID와 가입시 입력하신 이메일을 입력하여주세요.</p>
		
		<label for="id" id="joinFontSize">아이디를 적어주세요.</label>
			<input type="text" name="id" id="id" class="boxSize idPosi" required>
		<br>
		<div class="form-group col-xs-9 col-sm-9col-md-9 col-lg-9">
			<label for="email" id="joinFontSize">가입시 입력하신 이메일을 적어주세요.</label>
			<input type="email" name="email" id="findPwEmail" class="id form-control boxSize" placeholder="aaa123@aaa.com" required>
		</div>
		<br>
		<div class="form-group col-xs-3 col-sm-3 col-md-4 col-lg-3">
			<input type="submit" id="modRandPwBtn" value="비밀번호 찾기" class="dup btn btn btn-block m-t-md boxSize" onclick="modRandPw()">
			<br><span id="modPwState">&nbsp;</span>
		</div>
	
		<h3><a href="${contextPath}/member/main.do">홈화면으로<i class="fa fa-sign-out"></i></a></h3>
	</div>
</section>