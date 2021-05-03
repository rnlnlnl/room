<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
%>
<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<div class="hoc container clear">
	<div id="reviewDiv">
		<div class="inline">
			<p>
				<span class="name">상품명 : </span>
				<span class="value">${reviewMap.itemBean.itemname}</span>
				<a href="${contextPath}/item/readProduct.do?itemNo=${reviewMap.itemBean.itemno}">상품보러가기</a>
			</p>

			<ul class="starrating">
				<c:forEach begin="1" end="${reviewMap.boardBean.scope}" var="i">
					<li>
						<i class="fa coloured fa-star"></i>
					</li>
				</c:forEach>
				<c:forEach begin="1" end="${5-reviewMap.boardBean.scope}" var="i">
					<li>
						<i class="fa fa-star-o"></i>
					</li>
				</c:forEach>
			</ul>
		</div>

		<div>
			<p>
				<span class="name">제목 : </span>
				<span class="value">(${reviewMap.boardBean.postno})${reviewMap.boardBean.title}</span>
			</p>
		</div>

		<div class="inline">
			<p>
				<span class="name">작성자 : </span>
				<span class="value">${reviewMap.boardBean.writer}</span>
			</p>
			<p>
				<span class="value">
					<fmt:formatDate value="${reviewMap.boardBean.writedate}" pattern="yy년 MM월 dd일" />
				</span>
			</p>
		</div>

		<div class="contentBox">
			<div>${reviewMap.boardBean.content}</div>
		</div>

		<hr>
		<div>
			<h2 class="bold absolute">후기 사진</h2>

			<div id="reviewImgBox" class="center">
				<c:if test="${fn:length(reviewMap.fileList)==1}">
					<div class="reviewImg inline" style="background-image: url('${contextPath}/css/images/upload/boardUpload/${reviewMap.fileList[0]}');"></div>
				</c:if>
				<c:if test="${fn:length(reviewMap.fileList)!=1}">
					<p class="reviewSlidButtonBox clear">
						<i class="fa fa-caret-left leftImg fl_left"></i> <i class="fa fa-caret-right rightImg fl_right"></i>
					</p>
					<c:forEach items="${reviewMap.fileList}" var="img" varStatus="i">
						<c:if test="${i.index == 0}">
							<div class="reviewImg inline" style="background-image: url('${contextPath}/css/images/upload/boardUpload/${img}');"></div>
						</c:if>
						<c:if test="${i.index != 0}">
							<div class="reviewImg inline initDisplayNone" style="background-image: url('${contextPath}/css/images/upload/boardUpload/${img}');"></div>
						</c:if>
					</c:forEach>
				</c:if>
			</div>
		</div>
	</div>
</div>
<div>
	<button type="button">수정</button>
	<button type="button">삭제</button>
	<button type="button">목록으로</button>
</div>

<script type="text/javascript">
	var imgCount = ${fn:length(reviewMap.fileList)-1};
	var nowImg = 0;
	
	$(".leftImg").click(function(){
		nowImg--;
		if(nowImg < 0){
			nowImg = imgCount;
		}

		$("#reviewImgBox").children("div").addClass("initDisplayNone");
		
		$("#reviewImgBox").children("div").eq(nowImg).removeClass("initDisplayNone");
	});
	
	$(".rightImg").click(function(){
		nowImg++;
		
		if(nowImg > imgCount){
			nowImg = 0;
		}

		$("#reviewImgBox").children("div").addClass("initDisplayNone");
		
		$("#reviewImgBox").children("div").eq(nowImg).removeClass("initDisplayNone");
	});
		
</script>