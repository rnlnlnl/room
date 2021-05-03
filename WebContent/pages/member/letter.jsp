<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:if test="${empty param.letterCenter}">
	<c:set var="letterCenter" value="receiveLetter"></c:set>
</c:if>
<c:if test="${not empty param.letterCenter}">
	<c:set var="letterCenter" value="${param.letterCenter}"></c:set>
</c:if>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>쪽지함</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link href="${contextPath}/css/layout.css" rel="stylesheet" type="text/css" media="all">
<link href="${contextPath}/css/roomdy.css" rel="stylesheet" type="text/css" media="all">
<!-- jquery 1.7.2 ver min -->
<script src="${contextPath}/scripts/jquery.min.js"></script>
</head>
<body>

	<div id="letterBox">
		<nav class="clear">
			<ul>
				<li>
					<a href="${contextPath}/member/letterPage.do?letterCenter=writeLetter">쪽지 쓰기</a>
				</li>
				<li>
					<a href="${contextPath}/member/letterPage.do?letterCenter=receiveLetter">받은 쪽지함</a>
				</li>
				<li>
					<a href="${contextPath}/member/letterPage.do?letterCenter=sendLetter">보낸 쪽지함</a>
				</li>
			</ul>
		</nav>

		<div class="clear">
			<jsp:include page="letter/${letterCenter}.jsp" />
		</div>
	</div>

	<script type="text/javascript">
		$(".closeBtn").click(function() {
			window.close();
		})

		$(".allCheck").click(function() {
			$("input[type='checkbox']").attr('checked', 'true');
		});

		$(".letterDelBtn").click(function() {
			var letterNo = [];

			$("input[name='letterNo']:checked").each(function() {
				letterNo.push($(this).val());
			});

			console.log(letterNo)

			$.ajax({
				type : "post",
				url : "${contextPath}/member/delLetter.do",
				traditional : true,
				data : ({
					letterNo : letterNo,
					letterCenter : "${letterCenter}"
				}),
				dataType : "text",
				success : function(result) {
					location.href = '${contextPath}/member/letterPage.do';
				}
			});
		});
	</script>

	<jsp:include page="../../include/scripts.jsp" />
</body>
</html>