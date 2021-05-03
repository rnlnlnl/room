<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />
<%
	request.setCharacterEncoding("UTF-8");
%>

<p class="cls1">회원정보</p>
<div class="tableForm">
<table>

	<tr class="listMemberTr">
		<td class="listTd6">
			<b>아이디</b>
		</td>
		<td class="listTd7">
			<b>비밀번호</b>
		</td>
		<td class="listTd5">
			<b>이름</b>
		</td>
		<td class="listTd7">
			<b>닉네임</b>
		</td>
		<td class="listTd10">
			<b>이메일</b>
		</td>
		<td class="listTd7">
			<b>가입일</b>
		</td>
		<td class="listTd4">
			<b>우편번호</b>
		</td>
		<td class="listTd8">
			<b>주소1</b>
		</td>
		<td class="listTd10">
			<b>주소2</b>
		</td>
		<td class="listTd3">
			<b>인증</b>
		</td>
		<td class="listTd5">
			<b>스타일</b>
		</td>

		<td class="listTd3">
			<b>수정</b>
		</td>
		<td class="listTd3">
			<b>삭제</b>
		</td>
	</tr>

	<c:choose>
		<c:when test="${listMember==null}">
			<tr>
				<td colspan="5">
					<b>등록된 회원이 없습니다.</b>
				</td>
			</tr>
		</c:when>
		<c:when test="${listMember !=null }">
			<c:forEach var="memberbean" items="${listMember}">
				<tr class="listMemberIn">
					<td>${memberbean.id}</td>
					<td>${memberbean.pw}</td>
					<td>${memberbean.name}</td>
					<td>${memberbean.nickname}</td>
					<td>${memberbean.email}</td>
					<td id="listMemberJD">${memberbean.joindate}</td>
					<td>${memberbean.zipcode}</td>
					<td>${memberbean.addr1}</td>
					<td>${memberbean.addr2}</td>
					<td id="listMemberJD">${memberbean.auth}</td>
					<td id="listMemberJD">${memberbean.style}</td>
					<td id="listMemberJD">
						<a <%-- href="${contextPath}/member/modmemberForm.do?id=${memberbean.id}" --%>>수정</a>
					</td>
					<td id="listMemberJD">
						<a <%-- href="${contextPath}/member/delmemberForm.do?id=${memberbean.id} --%>">삭제</a>
					</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>

</table>
</div>