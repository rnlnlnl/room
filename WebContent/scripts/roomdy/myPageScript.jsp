<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- JSTL의 CORE라이브러리에 속한 태그들을 사용 하기 위해 링크 작성 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- 컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />


<script type="text/javascript">
	var email_Check = true;

	$(function() {
		if ($("#memAuth").val() == "고객") {
			$(".authB").css("display", "block");
			$(".authS").css("display", "none");
		} else if ($("#memAuth").val() == "판매자") {
			$(".authS").css("display", "block");
			$(".authB").css("display", "none");
		}

		$(".readonly").attr("readonly", "readonly");
		$(".disabled, input[name='style']").attr("disabled", "disabled");

		$(".closeModPwBox").click(function() {
			$("#modPwBox").css("display", "none");
		});

		$("#email").change(function() {
			email_Check = false;
		});

		$("#delMemberBtn").click(function() {
			$("#delMemForm").removeClass("initDisplayNone");
		});
	});

	function modPwShow() {
		$("#modPwBox").css("display", "block");
	}

	function checkPass() {
		var pass1 = $("#pw").val();
		var pass2 = $("#pw2").val();

		if (pass1 != pass2) {
			$("#passCheck").html("비밀번호가 다릅니다").css("color", "red");

		} else if ((pass1 == pass2) && (pass1 != "")) {
			$("#passCheck").html("비밀번호가 동일합니다").css("color", "green");
			$("#modPwBtn").css("display", "block");
		}
	}

	function modPw() {
		var dbOriPw = "${memberBean.pw}";
		var inputOriPw = $("#originalPw").val();
		var chagePw = $("#pw").val();

		if (dbOriPw != inputOriPw) {
			$("#modPw").text("현재 비밀번호와 입력하신 비밀번호가 일치하지 않습니다.");
			$("#modPw").css("color", "red");
		} else {
			alert("일치");
			$.ajax({
				type : 'POST',
				url : '${contextPath}/member/modPw.do',
				data : {
					pw : chagePw
				},
				success : function(result) {
					if (result == "success") {
						$("#modPw").text("비밀번호가 변경되었습니다.");
						$("#modPw").css("color", "green");
						$("#modPwBox").css("display", "none");
					} else {
						$("#modPw").text("비밀번호가 변경에 실패했습니다.");
						$("#modPw").css("color", "red");
					}
				},
				error : function() {
					alert("myPage의 modPw 에러");
				}
			});
		}
	}

	function modInfoMod() {
		$(".readonly").removeAttr("readonly")
		$(".readonly").removeClass("readonly");
		$(".modMode").css("display", "block");
		$("#memInfoModBtn").attr("onclick", "modFormCheck()")
		$("input[name='style']").removeAttr("disabled");
	}

	function certEmail() {
		var email = $("#email").val();
		if (email == "") {
			alert("메일주소를 입력하셔야 합니다.");
		} else {
			$
					.ajax({
						type : 'POST',
						url : '${contextPath}/member/checkDupEmail.do',
						data : {
							email : email
						},
						success : function(result) {
							if (result == "true") {
								$("#checkEmail").css("color", "green");
								$("#checkEmail").text("√ 사용 가능한 이메일 입니다.");

								/* 시간되면 팝업창 아닌 ajax와 modal 섞어서 인증창 띄우기 or 그냥 페이지에 input 나나태기 */
								window
										.open(
												'${contextPath}/member/emailCert.do?email='
														+ email, 'Email 인증요청',
												'width=500, height=400, menubar=no, status=no, toolbar=no');
							} else {
								$("#checkEmail").css("color", "red");
								$("#checkEmail").text("X 이미 사용중인 메일주소입니다. X");
							}
						},
						error : function() {
							alert("회원가입 이메일 인증 에러 joinMember Email cert error");
						}
					});
		}
	}

	function sample6_execDaumPostcode() {
		new daum.Postcode({
			oncomplete : function(data) {
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
						extraAddr += (extraAddr !== '' ? ', '
								+ data.buildingName : data.buildingName);
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

	function modFormCheck() {
		var id = document.getElementById("id");
		var pw = document.getElementById("pw");
		var pw2 = document.getElementById("pw2");
		var name = document.getElementById("name");
		var email = document.getElementById("email");
		var address = document.getElementById("addr");

		if (email_Check || $("#certBtn").is(":disabled")) {
			email_Check = true;
		} else {
			alert("메일 인증이 완료되지 않았습니다.");
			$("#email").focus();
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
		modMember();
	}

	function modMember() {
		$.ajax({
			type : 'POST',
			url : '${contextPath}/member/modMember.do',
			data : {
				id : $("#id").val(),
				nickname : $("#nickname").val(),
				email : $("#email").val(),
				zipcode : $("#zipcode").val(),
				addr1 : $("#addr1").val(),
				addr2 : $("#addr2").val(),
				style : $("input[name='style']").val()
			},
			success : function(result) {
				if (result == "true") {
					alert("회원 정보가 수정되었습니다.");
					document.reload();
				} else {
					alert("회원 정수 수정에 실패했습니다. 다시 시도해주세요.");
				}
			},
			error : function() {
				alert("myPage의 modPw 에러");
			}
		});
	}

	function delPwChe() {
		if ($("input[name='delConfPw']") == "${memberBean.pw}") {
			alert("회원탈퇴 되셨습니다.");
			$("#delMemForm").submit();
		} else {
			$("#delConfPwText").css("color", "red");
			$("#delConfPwText").text("X 비밀번호가 틀리셨습니다. X");
		}
	}
</script>