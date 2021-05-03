<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- JSTL의 CORE라이브러리에 속한 태그들을 사용 하기 위해 링크 작성 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />



<script type="text/javascript">

	var id_Check = false;
	var pass_Check = false;
	var email_Check = false;
	
	$(function() {
	    $("input:radio[name=auth]").click(function() {
	        if ($(this).val() == "B") {
	            $(".authB").css("display", "block");
	            $(".authS").css("display", "none");
	        } else if ($(this).val() == "S") {
	            $(".authS").css("display", "block");
	            $(".authB").css("display", "none");
	        }
	    });
	});

	
	// 아이디 중복 체크 하는 ajax를 사용한 소스
	function checkDupId() {
	
	    var id = $("#id").val();
	
	    if (!isAcceptableId($("#id").val())) {
	        $("#idCheck").css("color", "red");
	        $("#idCheck").text("3~15글자 사이의 소문자영어, 숫자만 입력 가능합니다.");
	        id_Check = false;
	        return;
	    }else{
	    	$.ajax({
		        type: "post",
		        url: "${contextPath}/member/checkDupId.do",
		        data: ({
		            id: $("#id").val()
		        }),
		        dataType: "text",
		        success: function(result) {
		            if (result == 1) {
		                $("#idCheck").css("color", "green");
		                $("#idCheck").text("사용가능한 아이디입니다.");
		                id_Check = true;
		            } else if( result == 0) {
		                $("#idCheck").css("color", "red");
		                $("#idCheck").text("이미 사용중인 아이디입니다.");
		                id_Check = false;
		            }else if( result == -1) {
		                $("#idCheck").css("color", "red");
		                $("#idCheck").text("탈퇴한 아이디 입니다. 사용 불가능 합니다.");
		                id_Check = false;
		            }
		        }
		    });
	    }  
	}
	
	function certEmail() {
		
	    var email = $("#email").val();
	
	    if (email == "") {
	        alert("메일주소를 입력하셔야 합니다.");
	    } else {
	        $.ajax({
	            type: 'POST',
	            url: '${contextPath}/member/checkDupEmail.do',
	            data: {
	                email: email
	            },
	            success: function(result) {
	            	
	            	if (result == "true") {
		                $("#checkEmail").css("color", "green");
		                $("#checkEmail").text("√ 사용 가능한 이메일 입니다.");
		               
		               /* 시간되면 팝업창 아닌 ajax와 modal 섞어서 인증창 띄우기 or 그냥 페이지에 input 나나태기 */
		                window.open('${contextPath}/member/emailCert.do?email=' + email, 'Email 인증요청','width=500, height=400, menubar=no, status=no, toolbar=no');
		            } else {
		                $("#checkEmail").css("color", "red");
		                $("#checkEmail").text("X 이미 사용중인 메일주소입니다. X");
		                id_Check = false;
		            }
	            },
	            error: function() {
	                alert("회원가입 이메일 인증 에러 joinMember Email cert error");
	            }
	        });
	    }
	}
	
	//아이디의 유효성 검사
	function isAcceptableId(input) {
	    if (input == "") {
	        return false;
	    }
	
	    if (input.length < 3 || input.length > 15) {
	        return false;
	    }
	
	    for (var i = 0; i < input.length; i++) {
	        if (input.charAt(i) < '0' || input.charAt(i) > '9') {
	            if (input.charAt(i) < 'a' || input.charAt(i) > 'z') {
	                return false;
	            }
	        }
	    }
	    return true;
	}
	
	
	function checkPass() {
	
	    var pass1 = $("#pw").val();
	    var pass2 = $("#pw2").val();
	
	    if (pass1 != pass2) {
	        $("#passCheck").html("비밀번호가 다릅니다").css("color", "red");
	
	    } else {
	        $("#passCheck").html("비밀번호가 동일합니다").css("color", "green");
	        pass_Check = true;
	
	    }
	}
	
	function sample6_execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            var addr = ''; // 주소 변수
	            var extraAddr = ''; // 참고항목 변수
	
	            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                addr = data.roadAddress;
	            } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                addr = data.jibunAddress;
	            }
	
	            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	            if (data.userSelectedType === 'R') {
	                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있고, 공동주택일 경우 추가한다.
	                if (data.buildingName !== '' && data.apartment === 'Y') {
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                if (extraAddr !== '') {
	                    extraAddr = ' (' + extraAddr + ')';
	                }
	
	            }
	
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
	            document.getElementById('zipcode').value = data.zonecode;
	            document.getElementById("addr1").value = addr;
	            // 커서를 상세주소 필드로 이동한다.
	            document.getElementById("addr2").focus();
	        }
	    }).open();
	}
	
	function joinFormCheck() {
	    var id = document.getElementById("id");
	    var pw = document.getElementById("pw");
	    var pw2 = document.getElementById("pw2");
	    var name = document.getElementById("name");
	    var email = document.getElementById("email");
	    var address = document.getElementById("addr");
		var never = document.getElementById("never");
	    var ne = document.getElementById("ne");
		
	    if($("#certBtn").is(":disabled")){
	    	email_Check=true;
		}
	    
	    if (pw.value.length < 8 || pw.value.length > 13) {
	        alert("비밀번호는 8자 ~ 12자 이내로 입력해야 합니다");
	        pw.value = ""
	        document.fr.pw.focus();
	        return false;
	    }
	
	    if (name.value == "") {
	        alert("이름을 입력해 주세요");
	        document.fr.name.focus();
	        return false;
	    }
	
	    if (nickname.value == "") {
	        alert("별명을 입력해주세요.")
	        document.fr.nickname.focus();
	        return false;
	    }
	
	    if (email.value == "") {
	        alert("이메일을 입력해 주세요");
	        document.fr.email.focus();
	        return false;
	    }
	
	    if (addr2.value == "") {
	        alert("주소를 입력해 주세요");
	        document.fr.addr2.focus();
	        return false;
	    }
	
	    if (zipcode.value == "") {
	        alert("우편 번호를 입력해 주세요");
	        document.fr.zipcode.focus();
	        return false;
	    }
	
	    if (document.getElementById("certBtn").disabled == false) {
	        alert("메일 인증이 완료되지 않았습니다.");
	        $("#email").focus();
	        return false;
	    }
		
	    if(never.checked){
	    	alert("약관에 동의해주세요");
	    	return false;
	    }
	    
	    if(ne.checked){
	    	alert("이메일 수신에 동의해주세요");
	    	return false;
	    }
	    
	    if(id_Check&&pass_Check&&email_Check){
	    	$("#joinform").submit();
	    }
	}
</script>

<form action="${contextPath}/member/addMember.do" method="post" id="joinform" name="fr">
	<section id="section">
		<label for="joinType" id="joinFontSize">가입유형을 체크해주세요</label>
		<nav id="typeList">
			<label for="authB" id="typeList" class="typeB_S">
					<input type="radio" name="auth" value="B" id="authB" checked onclick="joinCheck('b')"><!--onclick을 전달인자로 구분하겠금.  -->
					<span class="spanW"><b>구매자</b></span>
				</label>
				<label for="authS" id="typeList" class="typeB_S">
					<input type="radio" name="auth" value="S" id="authS" onclick="joinCheck('s')">
					<span class="spanW"><b>판매자</b></span>
				</label>
		</nav>
	<hr>
	<div id="typeList">
		<label for="id" id="joinFontSize">아이디</label>
		<span id="idCheck" name="idCheck" class="check_status">&nbsp;</span>
	</div>
		<input type="text" name="id" id="id" class="boxSize" onblur="checkDupId();" required />
		<br>
		
	<label for="pw" id="joinFontSize">비밀번호</label>
		<input type="password" name="pw" id="pw" class="boxSize" required autocomplete="off" />
		<br>
	<div id="typeList">
	<label for="pw2"  id="joinFontSize">비밀번호 재확인</label>
		<span id="passCheck"></span>
	</div>
		<input type="password" name="pw2" id="pw2" class="boxSize" onblur="return checkPass()" required autocomplete="off" />
	<br>
	<label for="name" class="authB"  id="joinFontSize">이름</label>
	<label for="name" class="authS"  id="joinFontSize">회사명</label>
		<input type="text" name="name" id="name" class="boxSize" required />
		<br>

	<label for="nickname" class="authB"  id="joinFontSize">닉네임</label>
	<label for="nickname" class="authS"  id="joinFontSize">사업자번호</label>
		<input type="text" name="nickname" id="nickname" class="boxSize" required />
		<br>

	<div class="row">
		<div class="form-group col-xs-9 col-sm-9col-md-9 col-lg-9" id="typeList">
			<label for="email" class="joinEmail"  id="joinFontSize">이메일</label>
			<b><span id="checkEmail">&nbsp;</span></b>
		</div>
		<div id="typeList">
			<input type="email" name="email" id="email" class="id form-control box_size" placeholder="hello@hello.com" required>
			<input type="button" id="certBtn" value="메일인증" class="dup btn btn btn-block m-t-md buttonBox" onclick="certEmail()">
		</div>
	</div><br>
	
	<div>
		<label for="addr2"  id="joinFontSize">주소</label>
		<div id="typeList">
			<input type="text" name="zipcode" id="zipcode" class="box_size" placeholder="우편번호" required readonly="readonly">
			<input type="button" onclick="sample6_execDaumPostcode()" class="buttonBox btn" value="주소검색">
		</div><br>
			<input type="text" id="addr1" name="addr1" class="boxSize" placeholder="주소">
			<br>
			<input type="text" id="addr2" name="addr2" class="boxSize" placeholder="상세주소" required>
	</div>
	<br>

	<div id="authBuyer" class="typeB_S">
		<label for="style"  id="joinFontSize">선호 스타일</label>
		<nav id="typeList">
			<label class="typeB_S">
				<input type="radio" name="style" id="qute" value="큐트" checked="checked">
				<span class="spanw">큐트</span>
			</label>
			
			<label class="typeB_S">
				<input type="radio" name="style" id="모던" value="modern"> 
				<span class="spanw">모던</span>
			</label>
				
			<label class="typeB_S">	
				<input type="radio" name="style" id="애니메이션" value="anymation">
				<span class="spanw">애니메이션</span>
			</label>
				
			<label class="typeB_S">	
				<input type="radio" name="style" id="smart" value="스마트">
				<span class="spanw">스마트</span>
			</label>	
		</nav>
	</div>
	
	
	<!-- <div id="authSeller">
	<label for="style">제작 가구</label>
	침대
	<input type="checkbox" name="style" id="bad" value="침대" checked="checked">
	책상/의자/가구
	<input type="checkbox" name="style" id="study" value="책상/의자/가구">
	벽지
	<input type="checkbox" name="style" id="plays" value="벽지">
	조명
	<input type="checkbox" name="style" id="other" value="조명">
	</div> -->
	<br>
	<div id="typeList">
	<label ><b id="joinFontSize">약관동의</b></label>&nbsp;<a class="looked" id="looking">닫기</a>
	</div>
			<div class="loo">
			<section id="sec01">
				<p class="act01">
제 1 조 (목적)
본 이용약관(이하 '약관')은 (사)RoomDy(이하 ‘회사’라 한다)가 제공하는 서비스 (이하 ‘서비스’라 한다 도메인명 http://www.roomdy.com) 이용자와 회사간의 이용 조건 및 절차, 회사와 이용자의 권리, 의무 및 이용에 관한 제반사항과 기타 필요한 사항을 구체적으로 규정함 을 목적으로 합니다.
제 2 조 (이용약관의 효력 및 변경)
(1)본 약관은 웹사이트에서 온라인으로 공시함으로써 효력을 발생하며, 합리적인 사유가 발 생할 경우 관련법령에 위배되지 않는 범위 안에서 개정될 수 있습니다. 개정된 약관은 온 라인에서 공지함으로써 효력을 발휘하며, 이용자의 권리 또는 의무 등 중요한 규정의 개 정은 사전에 공지합니다.
(2)회사는 합리적인 사유가 발생될 경우에는 이 약관을 변경할 수 있으며, 약관을 변경할 경 우에는 지체 없이 이를 사전에 공시합니다
(3)본 약관에 동의하는 것은 정기적으로 웹을 방문하여 약관의 변경사항을 확인하는 것에 동의함을 의미합니다. 변경된 약관에 대한 정보를 알지 못해 발생하는 이용자의 피해는 회사에서 책임지지 않 습니다.
회원은 변경된 약관에 동의하지 않을 경우 회원 탈퇴(해지)를 요청할 수 있으며, 변경된 약관의 효력 발생일로부터 7일 이후에도 거부의사를 표시하지 아니하고 서비스를 계속 사용할 경우 약관의 변경 사항에 동의한 것으로 간주됩니다.
제 3 조 (약관외 준칙)
본 약관에 명시되지 아니한 사항에 대해서는 전기통신기본법, 전기통신사업법 등 기타 관계 법령 및 회사가 정한 홈페이지의 세부이용지침 등의 규정에 의합니다.
제 4 조 (용어의 정의)
(1)본 약관에서 사용하는 용어는 다음과 같습니다.
①본 약관은 웹사이트에서 온라인으로 공시함으로써 효력을 발생하며, 합리적인 사유가 발 생할 경우 관련법령에 위배되지 않는 범위 안에서 개정될 수 있습니다. 개정된 약관은 온 라인에서 공지함으로써 효력을 발휘하며, 이용자의 권리 또는 의무 등 중요한 규정의 개 정은 사전에 공지합니다.
②회사는 합리적인 사유가 발생될 경우에는 이 약관을 변경할 수 있으며, 약관을 변경할 경 우에는 지체 없이 이를 사전에 공시합니다.
③본 약관에 동의하는 것은 정기적으로 웹을 방문하여 약관의 변경사항을 확인하는 것에 동의함을 의미합니다. 변경된 약관에 대한 정보를 알지 못해 발생하는 이용자의 피해는 회사에서 책임지지 않습니다.
④회원은 변경된 약관에 동의하지 않을 경우 회원 탈퇴(해지)를 요청할 수 있으며, 변경된 약관의 효력 발생일로부터 7일 이후에도 거부의사를 표시하지 아니하고 서비스를 계속 사용할 경우 약관의 변경 사항에 동의한 것으로 간주됩니다.
(2)회원은 변경된 약관에 동의하지 않을 경우 회원 탈퇴(해지)를 요청할 수 있으며, 변경된 약관의 효력 발생일로부터 7일 이후에도 거부의사를 표시하지 아니하고 서비스를 계속 사용할 경우 약관의 변경 사항에 동의한 것으로 간주됩니다.
제 5 조 (이용 계약의 성립)
(1)본 이용약관에 대한 동의는 이용신청 당시 해당 회사의 약관을 확인하시고 이용자가 '동 의함' 버튼을 누름으로써 의사표시를 합니다.
(2)이용계약은 이용고객의 본 이용약관 내용에 대한 동의와 이용신청에 대하여 회사의 이용 승낙으로 성립합니다.
제 6 조 (회원 가입 및 승낙)
(1)회원가입은 신청자가 온라인으로 회사가 제공하는 소정의 가입신청 양식에서 요구하는 사항을 기록하여 가입을 완료하는 것으로 성립됩니다.
(2)회사는 다음 각 항에 해당하는 경우 그 사유가 해소될 때까지 이용계약 성립을 유보할 수 있습니다.
①서비스 관련 제반 용량이 부족한 경우
②기술상 장애 사유가 있는 경우
(3)이용신청자는 다음 사항을 준수하여야 합니다.
①가입신청 양식에는 실명을 사용해야 합니다.
②타인의 명의를 사용하여 기재하지 않아야 합니다.
③가입신청 양식의 내용은 현재의 사실과 일치해야 합니다.
④사회의 안녕과 질서, 미풍양속을 저해할 목적으로 신청해서는 안됩니다.
⑤사실과 일치하지 않거나 잘못 입력한 개인정보로 발생하는 오류에 대한 책임은 회원에게 있습니다.
⑥이용신청자가 제공한 정보가 부정확하거나 현재의 사실과 일치하지 않는 경우, 또는 그러하다고 의심할 수 있는 합리적인 이유가 있는 경우 서비스 이용을 제한할 수 있습니다.
(4)회사는 이용신청고객이 관계법령에서 규정하는 미성년자일 경우에 승낙을 보류할 수 있습니다.
제 7 조 (회원의 유형)
- 홈페이지 이용 회원유형은 다음과 같습니다.
(1)일반회원(정회원) 이라 함은 홈페이지 이용악관에 동의하고, 회원가입 절차에 의해 회원 등록한 자이며, 고객번호와 이름, 주민등록번호로 기간계 시스템의 실 서비스 이용자로 인증된 자
(2)일반회원(준회원) 이라 함은 홈페이지 이용약관에 동의하고, 회원가입 절차에 의해 회원 등록한 자
(3)기업회원(정회원) 이라 함은 홈페이지 이용악관에 동의하고, 회원가입 절차에 의해 회원 등록한 자이며, 고객번호와 기업명, 사업자번호로 기간계 시스템의 실 서비스 이용자로 인증된 자
(4)기업회원(준회원) 이라 함은 홈페이지 이용약관에 동의하고, 회원가입 절차에 의해 회원 등록한 자
제 8 조 (이용자ID 부여 및 변경)
- 홈페이지 이용 회원유형은 다음과 같습니다.
(1)회사는 이용고객에 대하여 약관에 정하는 바에 따라 이용자 ID를 부여합니다.
(2)이용자ID는 원칙적으로 변경이 불가하며 부득이한 사유로 인하여 변경 하고자 하는 경우에는 해당 ID를 해지하고 재가입해야 합니다.
(3)이용자 ID는 다음 각 호의 사유에 해당하는 경우, 회원 또는 공사의 요청으로 변경할 수 있습니다.
①이용자 ID가 이용자의 전화번호, 주민등록번호 등으로 등록되어 이용자의 사생활을 침해할 우려가 있는 경우
②타인에게 혐오감을 주거나, 미풍양속에 저해되는 경우
③기타 공사의 합리적인 이유가 있는 경우
(4)회원은 이용 신청 시 기재한 회원정보가 변경되었을 경우 직접 서비스에 접속하여 수정할 수 있습니다. 이때 변경하지 않은 정보로 인하여 발생되는 문제의 책임은 회원에게 있습니다.
제 9 조 (회원 탈퇴 및 자격 상실 등)
(1)회원은 회원 본인이 회사의 서비스를 통하여 언제든지 탈퇴를 요청할 수 있으며, 회사는 즉시 회원탈퇴를 처리합니다
(2)회원이 다음 각 호의 사유에 해당하는 경우, 회사는 사전 통지 없이 회원 자격을 제한 및 정지시키거나, 기간을 정하여 서비스 이용의 일부를 중지 및 제한할 수 있습니다.
①가입 신청 시에 허위 내용을 등록한 경우
②회사에서 제공되는 정보를 변경하는 등 회사의 운영을 방해한 경우
③법령 또는 본 약관이 금지하거나 미풍양속에 반하는 행위를 하는 경우
- 다른 회원의 ID를 부정하게 사용하는 행위
- 다른 회원에 대한 개인 정보를 동의 없이 수집, 저장, 공개하는 행위
- 범죄와 결부된다고 객관적으로 판단되는 행위
- 기타 관련 법령에 위배되거나 회사가 정한 이용조건에 위배되는 경우
- 타인의 명예를 손상시키거나 불이익을 주는 경우
(3)회사가 회원의 자격을 제한 정지시킨 후, 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 회사는 회원자격을 상실시킬 수 있습니다.
(4)회사가 회원자격을 상실시키는 경우에는 회원 등록을 말소합니다. 이 경우 회원에게 이를 통지하고, 회원등록 말소 전에 최소한 30일 이상의 기간을 정하여 소명할 기회를 부여합니다.
(5)회사는 회원자격을 상실하고 등록이 말소된 회원이 다시 이용신청을 하는 경우 일정기간 그 승낙을 제한할 수 있습니다.
제 10 조 (서비스 이용 시간)
(1)서비스 이용은 회사의 업무상 또는 기술상 특별한 지장이 없는 한 연중무휴, 1일 24시간 운영을 원칙으로 합니다. 단, 회사는 시스템 정기점검, 증설 및 교체를 위해 회사가 정한 날이나 시간에 서비스를 일시중단할 수 있으며, 예정되어 있는 작업으로 인한 서비스 일 시 중단은 사전에 공지합니다.
(2)회사는 서비스를 특정범위로 분할하여 각 범위별로 이용가능시간을 별도로 지정할 수 있습니다. 다만 이 경우 그 내용을 공지합니다.
제 11 조 (서비스 변경 및 중지)
(1)회사는 수시로 서비스의 향상을 위하여 기존 서비스의 전부 또는 일부 내용을 별도의 통지 없이 변경할 수 있습니다.
(2)회사는 다음 각 호에 해당하는 경우 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다.
①긴급한 시스템 점검, 증설 및 교체 등 부득이한 경우
②정전, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 제공이 불가능할 경우
③기타 천재지변, 국가비상사태 등 불가항력적 사유가 있는 경우
(3)회사는 홈페이지상에서 결제가 동반하는 계약을 체결하는 서비스에 대해서 미성년자(만20세)의 경우 서비스를 제한합니다.
(4)회사는 서비스 변경, 중지로 발생하는 문제에 대해서는 어떠한 책임도 지지 않겠습니다.
제 12 조 (회원 ID와 비밀번호 관리에 대한 의무와 책임)
(1)회원 ID와 비밀 번호의 관리 소홀, 부정 사용에 의하여 발생하는 모든 결과에 대한 책임은 회원 본인에게 있으며, 회사의 시스템 고장 등 회사의 책임있는 사유로 발생하는 문제에 대해서는 회사가 책임을 집니다.
(2)회원은 본인의 ID 및 비밀번호를 제3자에게 이용하게 해서는 안되며, 회원 본인의 ID 및 비밀번호를 도난 당하거나 제3자가 사용하고 있음을 인지하는 경우에는 바로 회사에 통보 하고 회사의 안내가 있는 경우 그에 따라야 합니다.
(3)회원의 ID는 회사의 사전 동의 없이 변경할 수 없습니다.
제 13 조 (회원에 대한 통지)
(1)회원에 대한 통지를 하는 경우 회사는 회원이 등록한 전자우편 주소 또는 SMS 등으로 할 수 있습니다.
(2)회사는 불특정 다수 회원에 대한 통지의 경우 홈페이지 게시판 등에 게시함으로써 개별 통지에 갈음할 수 있습니다.
제 14 조 (게시물의 관리)
회사는 다음 각 호에 해당하는 게시물이나 자료를 사전통지 없이 삭제하거나 이동 또는 등록거부를 할 수 있습니다.
- 다른 회원 또는 제 3자에게 심한 모욕을 주거나 명예를 손상시키는 내용인 경우
- 공공질서 및 미풍양속에 위반되는 내용을 유포하거나 링크시키는 경우
- 불법복제 또는 해킹을 조장하는 내용인 경우
- 영리를 목적으로 하는 광고일 경우
- 범죄와 결부된다고 객관적으로 인정되는 내용일 경우
- 다른 이용자 또는 제 3자의 저작권 등 기타 권리를 침해하는 내용인 경우
- 회사에서 규정한 게시물 원칙에 어긋나거나, 게시판 성격에 부합하지 않는 경우
- 기타 관계법령에 위배된다고 판단되는 경우
제 15 조 (게시물에 대한 저작권)
(1)회원이 서비스 화면 내에 게시한 게시물의 저작권은 게시한 회원에게 귀속됩니다. 또한 회사는 게시자의 동의 없이 게시물을 상업적으로 이용할 수 없습니다. 다만 비영리 목적인 경우는 그러하지 아니하며, 또한 서비스내의 게재권을 갖습니다.
(2)회원은 서비스를 이용하여 취득한 정보를 임의 가공, 판매하는 행위 등 서비스에 게재된 자료를 상업적으로 사용할 수 없습니다.
(3)회사는 회원이 게시하거나 등록하는 서비스 내의 내용물, 게시 내용에 대해 제 14조 각 호에 해당된다고 판단되는 경우 사전통지 없이 삭제하거나 이동 또는 등록 거부할 수 있습니다.
제 16 조 (정보의 제공)
(1)회사는 회원에게 서비스 이용에 필요가 있다고 인정되는 각종 정보에 대해서 전자우편이나 서신우편 등의 방법으로 회원에게 제공할 수 있습니다.
(2)회사는 서비스 개선 및 회원 대상의 서비스 소개 등의 목적으로 회원의 동의 하에 추가적인 개인 정보를 요구할 수 있습니다.
제 17 조 (광고게재 및 광고주와의 거래)
(1)회사가 회원에게 서비스를 제공할 수 있는 서비스 투자기반의 일부는 광고게재를 통한 수익으로부터 나옵니다. 회원은 서비스 이용시 노출되는 광고게재에 대해 동의합니다.
(2)회사는 서비스상에 게재되어 있거나 본 서비스를 통한 광고주의 판촉활동에 회원이 참여하거나 교신 또는 거래를 함으로써 발생하는 손실과 손해에 대해 책임을 지지 않습니다.
제 18 조 (회사의 의무)
(1)회사는 법령과 본 약관이 금지하거나 미풍양속에 반하는 행위를 하지 않으며, 지속적, 안 정적으로 서비스를 제공하기 위해 노력할 의무가 있습니다.
(2)회사는 회원의 개인 신상 정보를 본인의 승낙 없이 타인에게 누설, 배포하지 않습니다. 다만, 전기통신 관련법령 등 관계 법령에 의하여 관계 국가기관 등의 요구가 있는 경우에 는 그러지 아니합니다.
(3)회사는 이용자의 귀책 사유로 인한 서비스 이용 장애에 대하여 책임을 지지 않습니다.
(4)회사는 서비스와 관련한 회원의 불만사항이 접수되는 경우 이를 즉시 처리하여야 하며, 즉시 처리가 곤란한 경우 그 사유와 처리 일정을 서비스 또는 전자우편을 통하여 해당 회원에게 통지하여야 합니다.
제 19 조 (이용자의 의무)
(1)이용자는 회원가입 신청 또는 회원정보 변경 시 실명으로 모든 사항을 사실에 근거하여 작성하여야 하며, 허위 또는 타인의 정보를 등록할 경우 일체의 권리를 주장할 수 없습니다.
(2)회원은 본 약관에서 규정하는 사항과 기타 회사가 정한 제반 규정, 공지사항 등 회사가 공지하는 사항 및 관계법령을 준수하여야 하며, 기타 회사의 업무에 방해가 되는 행위, 회사의 명예를 손상시키는 행위를 해서는 안됩니다.
(3)회원은 주소, 연락처, 전자우편 주소 등 이용계약사항이 변경된 경우에 해당 절차를 거쳐 이를 회사에 즉시 알려야 합니다.
(4)회사는 서비스와 관련한 회원의 불만사항이 접수되는 경우 이를 즉시 처리하여야 하며, 즉시 처리가 곤란한 경우 그 사유와 처리 일정을 서비스 또는 전자우편을 통하여 해당 회원에게 통지하여야 합니다
(5)회사가 관계법령 및 '개인정보 보호정책'에 의거하여 그 책임을 지는 경우를 제외하고 회 원에게 부여된 ID의 비밀번호 관리소홀, 부정사용에 의하여 발생하는 모든 결과에 대한 책임은 회원에게 있습니다.
(6)회원은 회사의 사전 승낙 없이 서비스를 이용하여 영업활동을 할 수 없으며, 그 영업활동 의 결과에 대해 회사는 책임을 지지 않습니다. 또한 회원은 이와 같은 영업활동으로 회사 가 손해를 입은 경우, 회원은 회사에 대해 손해배상의무를 지며, 회사는 해당 회원에 대해 서비스 이용제한 및 적법한 절차를 거쳐 손해배상 등을 청구할 수 있습니다.
(7)회원은 회사의 명시적 동의가 없는 한 서비스의 이용권한, 기타 이용계약상의 지위를 타 인에게 양도, 증여할 수 없으며 이를 담보로 제공할 수 없습니다.
(8)회원은 회사 및 제 3자의 지적 재산권을 침해해서는 안됩니다.
(9)회원은 다음 각 호에 해당하는 행위를 하여서는 안되며, 해당 행위를 하는 경우에 회사는 회원의 서비스 이용제한 및 적법 조치를 포함한 제재를 가할 수 있습니다.
- 회원가입 신청 또는 회원정보 변경 시 허위내용을 등록하는 행위
- 다른 이용자의 ID, 비밀번호, 주민등록번호를 도용하는 행위
- 이용자 ID를 타인과 거래하는 행위
- 회사로부터 특별한 권리를 부여 받지 않고 회사의 서버를 해킹하거나, 웹사이트 또는 게시된 정보의 일부분 또는 전체를 임의로
변경하는 행위
- 서비스에 위해를 가하거나 고의로 방해하는 행위
- 본 서비스를 통해 얻은 정보를 회사의 사전 승낙 없이 서비스 이용 외의 목적으로 복제하거나, 이를 출판 및 방송 등에 사용하거나,
제 3자에게 제공하는 행위
- 공공질서 및 미풍양속에 위반되는 저속, 음란한 내용의 정보, 문장, 도형, 음향, 동영상을 전송, 게시, 전자우편 또는 기타의 방법으로
타인에게 유포하는 행위
- 모욕적이거나 개인신상에 대한 내용이어서 타인의 명예나 프라이버시를 침해할 수 있는 내용을 전송, 게시, 전자우편 또는 기타의
방법으로 타인에게 유포하는 행위
- 다른 이용자를 희롱 또는 위협하거나, 특정 이용자에게 지속적으로 고통 또는 불편을 주는 행위
- 회사의 승인을 받지 않고 다른 사용자의 개인정보를 수집 또는 저장하는 행위
- 범죄와 결부된다고 객관적으로 판단되는 행위
- 본 약관을 포함하여 기타 회사가 정한 제반 규정 또는 이용 조건을 위반하는 행위
- 기타 관계법령에 위배되는 행위
제 20 조 (회사의 보안관리)
회사는 이용자의 개인정보가 분실, 도난, 누출, 변조 또는 훼손되지 않도록 안전성 확보에 필 요한 조치를 강구합니다. 다만, 회원이 게시판에 email, 등 온라인 상에서 자발적으로 제공하 는 개인정보는 다른 사람이 수집하여 사용할 가능성이 있으며 이러한 위험은 개인에게 책임 이 있으며 회사에는 일체의 책임이 없습니다.
제 21 조 (회사의 회원 정보 사용에 대한 동의와 철회)
(1)회원의 개인정보에 대해서는 회사의 서비스에서 제공하는 개인정보 보호정책이 적용됩니다.
(2)회사는 회사가 제공하는 서비스를 이용하는 회원을 대상으로 해당 서비스의 양적, 질적 향상을 위하여 회원의 개인식별이 가능한 개인 정보를 회원의 동의를 받아 이를 수집, 이용할 수 있습니다.
(3)회사가 수집하는 개인정보는 서비스의 제공에 필요한 최소한으로 하되, 필요한 경우 더 자세한 정보를 요구할 수 있습니다.
(4)회원이 제공한 개인정보는 회원의 동의 없이 제 3자에게 누설하거나 제공하지 않습니다. 단, 회사는 관련 법률에 어긋나지 않는 한 제휴사를 통해 회원에게 제공되는 서비스의 질을 향상시킬 목적이나 통계 작성 또는 시장 조사 등을 위하여 필요한 정보를 타사에게 제공하거나 공유할 수 있습니다.
(5)회사는 회원들이 회사 및 제휴 업체의 서비스를 편리하게 사용할 수 있도록 하기 위해 회원 정보를 제휴 업체에 제공할 수 있습니다. 이 경우 회사는 사전에 공지하며 이에 동의하지 않는 회원은 등록을 취소할 수 있습니다. 다만 계속 이용하는 경우 동의하는 것으로 간주합니다.
(6)회원은 회사에 제공한 개인정보의 수집과 이용에 대한 동의를 철회할 수 있습니다.
(7)회원은 언제든지 본인의 개인정보를 열람하고 변경사항을 정정할 수 있습니다.
(8)전기통신 사업법 등 법률 규정에 의해 국가 기관의 요구가 있는 경우, 수사상 목적이 있거나 정보통신윤리 위원회의 요청이 있는 경우 또는 기타 관계 법령 절차에 따른 정보제공 요청이 있는 경우 회원 정보가 제공될 수 있습니다.
(9)회사는 서비스를 통해 회원의 컴퓨터에 쿠키를 전송할 수 있습니다. 회원은 쿠키 수신을 거부하거나 쿠키 수신에 대해 경고하도록 브라우저 설정을 변경할 수 있습니다. 다만, 서비스에 링크된 웹사이트들이 개인정보를 수집하는 행위에 대해서는 회사가 책임지지 않습니다
제 22 조 (개인 정보 보유 및 이용기간)
(1)회사는 회원의 개인 정보를 탈퇴하기 전까지 보유합니다.
(2)회원은 본인이 탈퇴하기 전까지 회사에서 제공하는 서비스를 이용할 수 있습니다. 단, 본 서비스 약관에 위배되는 경우는 예외로 합니다.
제 23 조 (손해배상)
회사는 서비스에서 무료로 제공하는 서비스의 이용과 관련하여 개인정보보호정책에서 정하는 내용에 해당하지 않는 사항에 대하여는 어떠한 손해도 책임을 지지 않습니다.
제 24 조 (면책조항)
(1)회사는 천재지변, 전쟁 및 기타 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 대한 책임이 면제됩니다.
(2)회사는 기간통신 사업자가 전기통신 서비스를 중지하거나 정상적으로 제공하지 아니하여 손해가 발생한 경우 책임이 면제됩니다.
(3)회사는 서비스용 설비의 보수, 교체, 정기점검, 공사 등 부득이한 사유로 발생한 손해에 대한 책임이 면제됩니다.
(4)회사는 회원의 귀책사유로 인한 서비스 이용의 장애 또는 손해에 대하여 책임을 지지 않습니다.
(5)회사는 이용자의 컴퓨터 오류에 의해 손해가 발생한 경우, 또는 회원이 신상정보 및 전자우편 주소를 부실하게 기재하여 손해가 발생한 경우 책임을 지지 않습니다.
(6)회사는 회원이 서비스를 이용하여 기대하는 수익을 얻지 못하거나 상실한 것에 대하여 책임을 지지 않습니다.
(7)회사는 회원이 서비스를 이용하면서 얻은 자료로 인한 손해에 대하여 책임을 지지 않습니다. 또한 회사는 회원이 서비스를 이용하며 타 회원으로 인해 입게 되는 정신적 피해에 대하여 보상할 책임을 지지 않습니다.
(8)회사는 회원이 서비스에 게재한 각종 정보, 자료, 사실의 신뢰도, 정확성 등 내용에 대하여 책임을 지지 않습니다.
(9)회사는 이용자 상호간 및 이용자와 제 3자 상호 간에 서비스를 매개로 발생한 분쟁에 대해 개입할 의무가 없으며, 이로 인한 손해를 배상할 책임도 없습니다.
(10)회사에서 회원에게 무료로 제공하는 서비스의 이용과 관련해서는 어떠한 손해도 책임을 지지 않습니다.
제 25 조 (재판권 및 준거법)
(1)이 약관에 명시되지 않은 사항은 전기통신사업법 등 관계법령과 상관습에 따릅니다.
(2)회사의 정액 서비스 회원 및 기타 유료 서비스 이용 회원의 경우 회사가 별도로 정한 약관 및 정책에 따릅니다.
(3)서비스 이용으로 발생한 분쟁에 대해 소송이 제기되는 경우 회사의 본사 소재지를 관할하는 법원을 관할 법원으로 합니다.
※ 부칙
- (시행일) 본 약관은 게시일로부터 적용됩니다.
				</p>
			</section>
			</div>
			<div id="typeList">
			<input type="radio" name="eee" id="ok" value="okok" ><b>동의합니다.</b>
			<input type="radio" name="eee" id="never"  value="nonever" checked="checked"><b>동의하지 않습니다.</b><br>
			<br>
			</div>
			<div id="typeList">
			<label id="joinFontSize">이메일 수신동의</label><br>
			<input type="radio" name="ema" id="yes" value="yesyes" ><b>동의합니다.</b>
			<input type="radio" name="ema" id="ne"  value="nono" checked="checked"><b>동의하지 않습니다.</b><br>
			</div>
			<br><br>
	<div id="typeList">
	<input type="button" id="regBtn" class="buttonBox" value="회원가입" onclick="joinFormCheck()" />
	<input type="reset" id="setbtn" class="buttonBox" value="다시쓰기" />
	</div>
</section>
</form>
