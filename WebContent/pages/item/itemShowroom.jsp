<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<%--컨텍스트 패스 주소 정보 얻기 --%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<c:choose>
	<c:when test="${empty param.page }">
		<c:set var="page" value="1" />
	</c:when>
	<c:otherwise>
		<c:set var="page" value="${param.page }" />
	</c:otherwise>
</c:choose>

<script>

	$(function(){
		
		$("input[name='color'], input[name='style'], input[name='preferage'], input[name='sortBy']").change(function(){
			$(this).parent().parent().children('label').removeClass('active');
			$(this).parent().addClass('active');
		});
		
		
		$("input[value='${param.sortBy}']").parent().click();
		$("input[value='${param.color}']").parent().click();
		$("input[value='${param.style}']").parent().click();
		if('${param.minAge}' != '') $("input[name='minAge']").val('${param.minAge}');
		if('${param.maxAge}' != '') $("input[name='maxAge']").val('${param.maxAge}');
		
		$("input[name='sortBy']").change(function(){
			sortList($("input[name='sortBy']:checked").val(), ${page});
		});
		 
		$('#filterBtn').click(function(){
			$('form').attr('action', '${contextPath}/item/itemShowroom.do');
			$('form').submit();
		})
		
		
		$(".heart").change(function(){
			var isHeart = $(this).val();
			
			var itemNo =$(this).parent().children().first().val();
			
			likeItem(itemNo, isHeart, $(this).parent().children('span'));
			
			if(isHeart == 'true'){
				$(this).val('false');
				
				$(this).parent().parent().removeClass("hearted");
				$(this).parent().children('i').addClass('fa-heart-o').removeClass('fa-heart');
			}else{
				$(this).val('true');
				
				$(this).parent().parent().addClass("hearted");
				$(this).parent().children('i').removeClass('fa-heart-o').addClass('fa-heart');
			}
		});
		
		
	});
	
	function likeItem(itemNo, isHeart, heart){
		$.ajax({
	        type: "post",
	        url: "${contextPath}/item/like.do",
	        traditional : true,
	        data: ({
	        	itemNo : itemNo,
	        	isHeart : isHeart
	        }),
	        dataType: "text",
	        success: function(result) {
	        	heart.text(result);
	        }
	    });
	}

</script>

<div class="hoc container clear">
	<div class="content">
		<form>
			<div id="filterBox">
				<table>
					<tr>
						<td>색상</td>
						<td>
							<c:forEach var="color" items="${filterMap.colorFilter}">
								<label>
									<input name='color' type="radio" value='${color}'>${color}</label>
							</c:forEach>
						</td>
					</tr>
					<tr>
						<td>스타일</td>
						<td>
							<c:forEach var="style" items="${filterMap.styleFilter}">
								<label>
									<input name='style' type="radio" value='${style}'>${style}</label>
							</c:forEach>
						</td>
					</tr>
					<tr>
						<td>연령</td>
						<td>
							<input type="number" name="minAge" value="0">
							세 ~
							<input type="number" name="maxAge" value="20">
							세
						</td>
					</tr>
				</table>
				<button type="button" id="filterBtn">필터 적용</button>
			</div>

			<hr>
			<div id="gallery">
				<div id="sortBox" class="inline fl_right">
					<label class="active">
						<a href="${contextPath}/item/itemShowroom.do?page=${page}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=latest&itemCate=${param.itemCate}">
						 최신순
						 </a>
						<input type="radio" value="latest" name="sortBy" checked>
					</label>


					<label>
						<a href="${contextPath}/item/itemShowroom.do?page=${page}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=cost asc&itemCate=${param.itemCate}">
							 가격<i class="fa fa-caret-down"></i>
						</a>
						<input type="radio" value="cost asc" name="sortBy">
					</label>


					<label>
						<a href="${contextPath}/item/itemShowroom.do?page=${page}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=cost desc&itemCate=${param.itemCate}">
							가격<i class="fa fa-caret-up"></i>
						</a>
						<input type="radio" value="cost desc" name="sortBy">
					</label>


					<label>
						<a href="${contextPath}/item/itemShowroom.do?page=${page}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=heart desc&itemCate=${param.itemCate}">
							하트<i class="fa fa-caret-up"></i>
						</a>
						<input type="radio" value="heart desc" name="sortBy">
					</label>
				</div>

				<figure>
					<header class="heading bold">상품 목록</header>
					<ul class="nospace clear" id="itemList">
						<c:if test="${fn:length(productList) == 0}">
							<h1 class='bold'>등록된 상품이 없습니다.</h1>
						</c:if>
						<c:forEach var="product" items="${productList}" varStatus="status">
							<c:set value="${status.index}" var="i" />
							<c:if test="${i%4==0}">
								<li class="one_quarter first">
							</c:if>
							<c:if test="${i%4!=0}">
								<li class="one_quarter">
							</c:if>
							<article class="inline oneItem">
								<a class="bold" href="${contextPath}/item/readProduct.do?itemNo=${product.itemno}">
									<img class="btmspace-10" src="${contextPath}/css/images/upload/itemImg/${product.itemImg}">
									<span class="fl_left">${product.itemname}</span> <br> <span class="fl_right">${product.cost}원</span>
								</a>
								<span class="fl_left">판매 ${product.seller}</span> <span class="fl_right heartBox"> <label>
										<input type="hidden" value='${product.itemno}'>
										<input type="checkbox" class="heart" value='false'>
										<span>${product.heart}</span> <i class="fa fa-heart-o"></i>
									</label>
								</span>
								<span>${product.itemColor} | ${product.style} | ${product.preferage}</span>
							</article>
							</li>
						</c:forEach>
					</ul>
				</figure>
			</div>
			<input type='hidden' name='itemCate' value='${param.itemCate}'>
		</form>
		<hr>
		
		<div id="page_control" class="center bold">
			<c:if test="${startPage>pageBlock}">
				<a
					href="${contextPath}/item/itemShowroom.do?page=${startPage-pageBlock}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=${param.sortBy}&itemCate=${param.itemCate}"
				>
					<i class="fa fa-angle-double-left"></i>
				</a>
			</c:if>
			<c:if test="${page != 1 and pageCount > 1}">
				<a href="${contextPath}/item/itemShowroom.do?page=${page-1}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=${param.sortBy}&itemCate=${param.itemCate}">
					<i class="fa fa-angle-left"></i>
				</a>
			</c:if>
			<c:forEach begin="${startPage}" end="${endPage}" var="i">
				<a href="${contextPath}/item/itemShowroom.do?page=${i}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=${param.sortBy}&itemCate=${param.itemCate}" <c:if test="${page==i}">class='nowPage'</c:if>>[${i}]</a>
			</c:forEach>
			<c:if test="${page != pageCount and pageCount > 1}">
				<a href="${contextPath}/item/itemShowroom.do?page=${page+1}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=${param.sortBy}&itemCate=${param.itemCate}">
					<i class="fa fa-angle-right"></i>
				</a>
			</c:if>
			<c:if test="${endPage<pageCount}">
				<a href="${contextPath}/item/itemShowroom.do?page=${startPage+pageBlock}&color=${param.color}&style=${param.style}&minAge=${param.minAge}&maxAge=${param.maxAge}&sortBy=${param.sortBy}&itemCate=${param.itemCate}">
					<i class="fa fa-angle-double-right"></i>
				</a>
			</c:if>
		</div>
	</div>
</div>