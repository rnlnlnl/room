<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%--컨텍스트 패스 주소 정보 얻기 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<!--################################################################################################ -->
<div class="wrapper" id="slideBox">
	<div id="pageintro" class="hoc clear">
		<!-- ################################################################################################ -->
		<div class="introtxt">
			<h2 class="heading">ROOMDY</h2>
			<p>상상이 현실이 되는 공간을 꾸며보세요.</p>
		</div>
		<!-- ################################################################################################ -->
		<div class="clear"></div>
	</div>

	<div id="slideButtonBox" class="inline">
		<p class="startBanner">
			<i class="fa fa-play-circle"></i>
		</p>
		<p class="stopBanner">
			<i class="fa fa-stop-circle"></i>
		</p>

	</div>
</div>
<!-- ################################################################################################ -->
<div class="wrapper row4">
	<section id="holtypes" class="hoc clear">
		<!-- ################################################################################################ -->
		<h2 class="heading underline center">ROOMDY를 만나보세요</h2>
		<ul class="nospace group">
			<li class="one_third first">
				<article>
					<a class="btn" href="${contextPath}/item/itemShowroom.do?itemCate=chair"> <i class="fas fa-chair"></i>
					</a>
					<h2 class="heading bold">의자</h2>
				</article>
			</li>
			<li class="one_third">
				<article>
					<a class="btn" href="${contextPath}/item/itemShowroom.do?itemCate=closet"> <i class="fas fa-door-closed"></i>
					</a>
					<h4 class="heading bold">옷장</h4>
				</article>
			</li>
			<li class="one_third">
				<article>
					<a class="btn" href="${contextPath}/item/itemShowroom.do?itemCate=light"> <i class="fas fa-lightbulb"></i>
					</a>
					<h4 class="heading bold">조명</h4>
				</article>
			</li>
			<li class="one_third first">
				<article>
					<a class="btn" href="${contextPath}/item/itemShowroom.do?itemCate=wallpaper"> <i class="fas fa-scroll"></i>
					</a>
					<h4 class="heading bold">벽지</h4>
				</article>
			</li>
			<li class="one_third">
				<article>
					<a class="btn" href="${contextPath}/item/itemShowroom.do?itemCate=toy"> <i class="fas fa-dice"></i>
					</a>
					<h4 class="heading bold">장난감</h4>
				</article>
			</li>
			<li class="one_third">
				<article>
					<a class="btn" href="${contextPath}/item/itemShowroom.do?itemCate=desk"> <i><img src="${contextPath}/css/images/main/desk.png" style="bottom: 5%; position: relative; left: 1%;"></i>
					</a>
					<h4 class="heading bold">책상</h4>
				</article>
			</li>
		</ul>
		<!-- ################################################################################################ -->
	</section>
</div>
<!-- ################################################################################################ -->
<div class="wrapper bgded overlay">
	<div class="hoc container clear">
		<!-- ################################################################################################ -->
		<h2 class="heading">ROOMDY 상품 추천</h2>
		<p class="btmspace-50">
			<c:choose>
				<c:when test="${empty memberId }">
				지금 ROOMDY에서 가장 hot한 상품들 입니다. 
			</c:when>
				<c:otherwise>
				고객님의 취향에 맞는 상품들을 준비했습니다.
			</c:otherwise>
			</c:choose>
		</p>
		<ul class="nospace group elements">
			<c:forEach items="${styleItemList}" var="item" varStatus="status">
				<c:if test="${status.index == 0}">
					<li class="one_quarter first">
				</c:if>
				<c:if test="${status.index != 0}">
					<li class="one_quarter">
				</c:if>

				<figure class="elementwrapper">
					<a class="imgoverlay styleImg" href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}" style="background-image: url('${contextPath}/css/images/upload/itemImg/${item.itemImg}');"> </a>
					<figcaption class="group">
						<div class="fl_left">${item.itemname}</div>
						<a href="${contextPath}/item/readProduct.do?itemNo=${item.itemno}" class="fl_right">${item.cost}원<i class="fa fa-eye"></i>
						</a>
					</figcaption>
				</figure>
				</li>
			</c:forEach>
		</ul>
		<!-- ################################################################################################ -->
		<div class="clear"></div>
	</div>
</div>
<!-- ################################################################################################ -->
<div class="wrapper row4">
	<div class="hoc container clear">
		<!-- ################################################################################################ -->
		<h2 class="heading">ROOMDY 최근 후기</h2>
		<p class="btmspace-50">따끈따끈한 ROOMDY 상품 후기를 만나보세요.</p>
		<ul id="lastminute" class="nospace group elements">
			<c:forEach items="${reviewList}" var="review" varStatus="status">
				<c:if test="${status.index == 0}">
					<li class="one_third first">
				</c:if>
				<c:if test="${status.index != 0}">
					<li class="one_third">
				</c:if>
				<article class="elementwrapper">
					<figure>
						<a class="imgoverlay mainReviewImg" href="${contextPath}/board/readReview.do?postno=${review.boardBean.postno}" style="background-image: url('${contextPath}/css/images/upload/boardUpload/${review.fileSrc}'); "> </a>
						<figcaption class="group">
							<div class="fl_left">${review.itemBean.itemname}</div>
							<a href="${contextPath}/board/readReview.do?postno=${review.boardBean.postno}" class="fl_right"> <i class="fa fa-eye"></i>
							</a>
						</figcaption>
					</figure>
					<div class="elementinfo">
						<ul class="starrating">
							<c:forEach begin="1" end="${review.boardBean.scope}" var="i">
								<li>
									<i class="fa coloured fa-star"></i>
								</li>
							</c:forEach>
							<c:forEach begin="1" end="${5 - review.boardBean.scope}" var="i">
								<li>
									<i class="fa fa-star-o"></i>
								</li>
							</c:forEach>
						</ul>
						<h4 class="heading">${review.boardBean.title}</h4>
						<ul class="meta">
							<li>
								</i><strong>${review.itemBean.cost}</strong>
								<span class="font-xs">(원)</span>
							</li>
							<li>
								<a href="${contextPath}/board/readReview.do?postno=${review.boardBean.postno}">View Details &raquo;</a>
							</li>
						</ul>
					</div>
				</article>
				</li>
			</c:forEach>
		</ul>
		<!-- ################################################################################################ -->
		<div class="clear"></div>
	</div>
</div>
<!-- ################################################################################################ -->
<div class="wrapper row3">
	<div id="contactinfo" class="hoc clear">
		<!-- ################################################################################################ -->
		<ul class="nospace group">
			<li class="one_half first">
				<div class="infobox">
					<i class="fa fa-building-o"></i>
					<ul class="nospace">
						<li><i class="fa fa-envelope"></i> roomdy@mail.dy</li>
						<li><i class="fa fa-phone"></i> (+051) 000 8282</li>
					</ul>
				</div>
			</li>
			<li class="two_quarter">
				<div class="infobox">
					<i class="fa fa-users"></i>
					<ul class="nospace">
						<li>
							<a href="#">안다수니 김지연</a>
						</li>
						<li>
							<a href="#">정수영 김병선 윤석현</a>
						</li>
					</ul>
				</div>
			</li>
		</ul>
		<!-- ################################################################################################ -->
		<div class="clear"></div>
	</div>
</div>
<!-- ################################################################################################ -->

<script type="text/javascript">
	var count = 1;
	var maxCount = 5;
	var interval;

	timer();
	slide();

	function timer() {
		interval = setInterval(function() {
			slide()
		}, 5000);
	}

	function slide() {
		var imgSrc = "${contextPath}/css/images/main/main" + count + '.jpg';

		$("#slideBox").css({
			"background-image" : "url(" + imgSrc + ")"
		});

		count++;

		if (count > maxCount) {
			count = 1;
		}
	}

	$(".stopBanner").click(function() {
		clearInterval(interval);
	});

	$(".startBanner").click(function() {
		timer();
	});
</script>