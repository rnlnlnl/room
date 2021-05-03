package item;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import bean.CartBean;
import bean.ItemBean;
import bean.MemberBean;
import bean.OptionBean;
import bean.OrderBean;
import bean.OrderItemBean;
import board.BoardService;
import member.MemberService;

//컨텍스트 패스가 /member 로 시작하는 모든 요청은 이 서블릿에서 처리합니다
@WebServlet("/item/*")
public class ItemController extends HttpServlet {
	ItemDAO iDAO;

	// init()메소드에서 MemberDAO객체를 초기화함.
	@Override
	public void init() throws ServletException {
		iDAO = new ItemDAO();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doIt(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doIt(request, response);
	}

	public void doIt(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		// 뷰페이지(요청한 작업을 완료한 후 보여줄 페이지) 주소를 저장할 변수
		String nextPage = null;
		boolean isRedirect = false;

		// 이 서블릿을 요청한 페이지 주소얻기
		String path = request.getPathInfo();
		System.out.println("Item 요청 주소 path :  " + path);

		// 실제로 요청을 처리할 서비스 객체, 이안에 모든 처리 메소드 들어있음
		ItemService service = new ItemService();
		MemberService mService = new MemberService();
		BoardService bService = new BoardService();

		HttpSession session = request.getSession();

		// ajax / javascirpt 로 출력할 때 사용할 printWrite 객체 생성
		PrintWriter out = response.getWriter();

		// path if문 순서 : 페이지 이동 작업 - service 전달 - ajax 작업 순으로 정렬

		/*
		 * ##########################################페이지 이동##########################################
		 */
		if (path.equals("/itemUploadPage.do")) { // 상품 등록 페이지로 이동하는 작업
			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "item/uploadItem.jsp");
		} else if (path.equals("/addWaybillPopup.do")) { //운송장번호 등록 팝업창열기  2월7일 윤석현 추가
			nextPage = "../pages/item/addParcelPopup.jsp";
			isRedirect = false; //그냥 팝업창만 띄워주는 요청이라 디스패치방식으로
		}
		/* ##########################################service작업########################################## */
		else if (path.equals("/itemUpload.do")) { // 상품 정보 DB에 등록하는 작업

			Map<String, Object> itemInfo = upload(request, response);

			ItemBean itemBean = null;
			List<OptionBean> options = new ArrayList<OptionBean>();

			ArrayList<String> styles = (ArrayList<String>) itemInfo.get("style");
			ArrayList<String> optName = (ArrayList<String>) itemInfo.get("optName");
			ArrayList<String> optCost = (ArrayList<String>) itemInfo.get("optCost");

			String seller = (String) session.getAttribute("memberId");

			String itemname = (String) itemInfo.get("itemName");
			int dueDate = Integer.parseInt((String) itemInfo.get("dueDate"));
			String itemCate = (String) itemInfo.get("itemCate");
			String itemColor = (String) itemInfo.get("itemColor");
			int cost = Integer.parseInt((String) itemInfo.get("itemCost"));
			int preferage = Integer.parseInt((String) itemInfo.get("preferage"));
			int amount = Integer.parseInt((String) itemInfo.get("amount"));
			String style = styles.toString().substring(1, styles.toString().length() - 1);
			String itemImg = (String) itemInfo.get("itemImg");

			itemBean = new ItemBean(seller, cost, itemname, itemCate, itemColor, preferage, style, amount, itemImg);

			itemBean.setDueDate(dueDate);

			for (int i = 0; i < optName.size(); i++) {
				OptionBean optBean = new OptionBean(i, Integer.parseInt(optCost.get(i)), optName.get(i));
				options.add(optBean);
			}

			itemInfo.clear();

			itemInfo.put("itemBean", itemBean);
			itemInfo.put("options", options);

			service.addItem(itemInfo);

			nextPage = "../pages/defaultMain.jsp";
		} else if (path.equals("/itemMod.do")) { // 상품 정보 수정하는 DB 작업
			Map<String, Object> modItemInfo = upload(request, response);

			ItemBean itemBean = null;
			List<OptionBean> options = new ArrayList<OptionBean>();

			ArrayList<String> styles = (ArrayList<String>) modItemInfo.get("style");
			ArrayList<String> optName = (ArrayList<String>) modItemInfo.get("optName");
			ArrayList<String> optCost = (ArrayList<String>) modItemInfo.get("optCost");

			int itemNo = Integer.parseInt((String) modItemInfo.get("itemNo"));
			String itemname = (String) modItemInfo.get("itemName");
			int cost = Integer.parseInt((String) modItemInfo.get("itemCost"));
			int preferage = Integer.parseInt((String) modItemInfo.get("preferage"));
			int amount = Integer.parseInt((String) modItemInfo.get("amount"));
			String itemCate = (String) modItemInfo.get("itemCate");
			String itemColor = (String) modItemInfo.get("itemColor");
			String style = styles.toString().substring(1, styles.toString().length() - 1);
			String itemImg = (String) modItemInfo.get("itemImg");

			itemBean = new ItemBean(itemNo, cost, itemname, itemCate, itemColor, preferage, style, amount, itemImg);

			for (int i = 0; i < optName.size(); i++) {
				OptionBean optBean = new OptionBean(itemNo, Integer.parseInt(optCost.get(i)), optName.get(i));
				options.add(optBean);
			}

			modItemInfo.clear();

			modItemInfo.put("itemBean", itemBean);
			modItemInfo.put("options", options);

			service.modItem(modItemInfo);

			nextPage = "itemList.do";
		} else if (path.equals("/itemList.do")) { // 본인이 판매하는 모든 상품 목록을 조회하는 작업

			String seller = (String) session.getAttribute("memberId");

			ArrayList<ItemBean> itemList = service.listItem(seller);

			request.setAttribute("itemList", itemList);
			request.setAttribute("center", "item/listItem.jsp");
			nextPage = "../pages/defaultMain.jsp";
		} else if (path.equals("/readItem.do")) { // 본인이 판매하는 모든 상품 목록을 조회하는 작업
			int itemNo = Integer.parseInt(request.getParameter("itemNo"));

			Map itemInfo = service.readItem(itemNo);

			request.setAttribute("itemInfo", itemInfo);
			request.setAttribute("center", "item/readItem.jsp");

			nextPage = "../pages/defaultMain.jsp";
		} else if (path.equals("/chageItemState.do")) { // 본인이 판매하는 모든 상품 목록을 조회하는 작업
			int itemNo = Integer.parseInt(request.getParameter("itemNo"));

			service.chageItemState(itemNo);

			nextPage = "itemList.do";
			isRedirect = true;
		} else if (path.equals("/readProduct.do")) { // 판매하는 상품 상세보기
			int itemNo = Integer.parseInt(request.getParameter("itemNo"));

			Map itemInfo = service.readItem(itemNo);
			List reviewList = bService.listReview(itemNo, 0, 100);

			request.setAttribute("itemInfo", itemInfo);
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("center", "item/readProduct.jsp");

			nextPage = "../pages/defaultMain.jsp";
		} else if (path.equals("/orderPage.do")) {
			String buyer = (String) session.getAttribute("memberId");
			int[] selectedItemNo = Arrays.stream(request.getParameterValues("itemNo")).mapToInt(Integer::parseInt).toArray();

			List<Map<String, Object>> selectedItemList = new ArrayList<Map<String, Object>>();

			if (request.getParameter("isDirect").equals("direct")) {
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				int itemAmount = Integer.parseInt(request.getParameter("amount"));

				ItemBean itemBean = service.getItemInfo(itemNo);
				CartBean cartBean = new CartBean(itemAmount);
				List optList = new ArrayList();

				String[] optName = request.getParameterValues("optName");
				if (optName != null) {
					int[] optCost = Arrays.stream(request.getParameterValues("optCost")).mapToInt(Integer::parseInt).toArray();
					int[] optAmount = Arrays.stream(request.getParameterValues("optAmount")).mapToInt(Integer::parseInt).toArray();

					JSONArray jsonOptArray = new JSONArray();

					for (int i = 0; i < optName.length; i++) {
						JSONObject opt = new JSONObject();

						opt.put("optName", optName[i]);
						opt.put("optCost", optCost[i]);
						opt.put("optAmount", optAmount[i]);

						optList.add(opt);
					}
				}

				Map<String, Object> cartItem = new HashMap<String, Object>();
				cartItem.put("itemBean", itemBean);
				cartItem.put("cartBean", cartBean);
				cartItem.put("optList", optList);

				selectedItemList.add(cartItem);
			} else {
				selectedItemList = service.selectedItemList(buyer, selectedItemNo);
			}

			MemberBean buyerInfo = mService.infoMember(buyer);

			request.setAttribute("selectedItemList", selectedItemList);
			request.setAttribute("buyerInfo", buyerInfo);

			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "item/payOrder.jsp");
		}

		else if (path.equals("/order.do")) {
			OrderBean orderBean = new OrderBean();
			List<OrderItemBean> orderItemList = new ArrayList<OrderItemBean>();

			String buyer = (String) session.getAttribute("memberId");
			String recipient = request.getParameter("recipient");
			int reczipcode = Integer.parseInt(request.getParameter("reczipcode"));
			String recaddr1 = request.getParameter("recaddr1");
			String recaddr2 = request.getParameter("recaddr2");
			String recphone = request.getParameter("recphone");

			orderBean.setOrderer(buyer);
			orderBean.setRecipient(recipient);
			orderBean.setReczipcode(reczipcode);
			orderBean.setRecaddr1(recaddr1);
			orderBean.setRecaddr2(recaddr2);
			orderBean.setRecphone(recphone);

			int[] itemNos = Arrays.stream(request.getParameterValues("itemNo")).mapToInt(Integer::parseInt).toArray();

			for (int i = 0; i < itemNos.length; i++) {
				OrderItemBean orderItemBean = new OrderItemBean();

				orderItemBean.setItemno(itemNos[i]);
				orderItemBean.setOrderamount(Integer.parseInt(request.getParameterValues("cartamount")[i]));
				orderItemBean.setOrderOpt(request.getParameterValues("opt")[i]);

				orderItemList.add(orderItemBean);
			}

			service.addOrder(orderBean, orderItemList);

			request.setAttribute("center", "item/orderSuccess.jsp"); //원래는 결제 페이질 넘어가야함 없으니까 일단 결제완료 페이지로 이동
			nextPage = "../pages/defaultMain.jsp";
		} else if (path.equals("/listOrder.do")) {
			String auth = (String) session.getAttribute("auth");
			String id = (String) session.getAttribute("memberId");

			List orderList = service.listOrder(id, auth);

			request.setAttribute("orderList", orderList);
			request.setAttribute("center", "item/listOrder.jsp");

			nextPage = "../pages/defaultMain.jsp";
		} else if (path.equals("/cartList.do")) { //장바구니 페이지 보여주기
			String buyer = (String) session.getAttribute("memberId");

			List cartList = service.cartList(buyer);

			request.setAttribute("cartList", cartList);

			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "item/cartList.jsp");
		} else if (path.equals("/search.do")) {
			String searchText = request.getParameter("searchText");
			String id = (String) session.getAttribute("memberId");
			String auth = (String) session.getAttribute("auth");

			Map<String, Object> searchMap = service.search(searchText);
			List<ItemBean> styleItemList = service.styleItemList(id, auth);

			request.setAttribute("searchMap", searchMap);
			request.setAttribute("styleItemList", styleItemList);

			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "item/search.jsp");
		} else if (path.equals("/readOrderItem.do")) {
			int orderNo = Integer.parseInt(request.getParameter("orderNo"));

			List<Map<String, Object>> orderItemList = service.orderItemList(orderNo);

			request.setAttribute("orderItemList", orderItemList);

			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "item/orderItemList.jsp");
		} else if (path.equals("/listSoldItem.do")) {
			String seller = (String) session.getAttribute("memberId");

			List<Map<String, Object>> listSoldItem = service.listSoldItem(seller);

			request.setAttribute("listSoldItem", listSoldItem);

			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "item/listSoldItem.jsp");
		} else if (path.equals("/modCartItemPopupPage.do")) { // 상품 등록 페이지로 이동하는 작업
			String buyer = (String) session.getAttribute("memberId");
			int itemNo = Integer.parseInt(request.getParameter("itemNo"));

			Map<String, Object> cartItem = service.readCartItem(buyer, itemNo);
			List optList = service.getOptList(itemNo);

			request.setAttribute("cartItem", cartItem);
			request.setAttribute("optList", optList);

			nextPage = "../pages/item/modCartPopup.jsp";
		} else if (path.equals("/itemShowroom.do")) { // 판매하는 모든 상품 조회하는 작업
			String itemCate = request.getParameter("itemCate");
			String sortBy = request.getParameter("sortBy");
			String colorFilter = request.getParameter("color");
			String styleFilter = request.getParameter("style");
			int minAge = 0, maxAge = 100;
			
			if (request.getParameter("minAge") != null && !request.getParameter("minAge").equals(""))
				minAge = Integer.parseInt(request.getParameter("minAge"));

			if (request.getParameter("maxAge") != null && !request.getParameter("maxAge").equals(""))
				maxAge = Integer.parseInt(request.getParameter("maxAge"));

			if (sortBy == null || sortBy.equals("") || sortBy.equals("latest")) {
				sortBy = "itemno";
			}

			String pageString = request.getParameter("page");
			int page;

			if (pageString == null) {
				page = 1;
			}
			else {
				page = Integer.parseInt(pageString);
			}

			/* =============================== 필터 조건 골라오기 ====================== */
			Map filterMap = service.filterMap();
			request.setAttribute("filterMap", filterMap);
			/* ======================================================================== */

			String isAjax = request.getParameter("isAjax");

			/* ==========페이징 작업========= */

			int pageSize = 100; //한 페이지에 보여줄 글 개수

			int startRow = (page - 1) * pageSize;

			int postCount = service.countItem(itemCate, colorFilter, styleFilter, minAge, maxAge);
			int pageCount = postCount / pageSize + (postCount % pageSize == 0 ? 0 : 1);

			int pageBlock = 5; //한 페이지에 보여질 페이징 갯수

			int startPage = ((page / pageBlock) - (page % pageBlock == 0 ? 1 : 0)) * pageBlock + 1;
			int endPage = startPage + pageBlock - 1;

			if (endPage > pageCount)
				endPage = pageCount;

			request.setAttribute("pageCount", pageCount);
			request.setAttribute("startPage", startPage);
			request.setAttribute("endPage", endPage);
			request.setAttribute("pageBlock", pageBlock);

			/* ==========페이징 작업 끝========= */
			ArrayList<ItemBean> productList = service.productList(itemCate, colorFilter, styleFilter, minAge, maxAge, sortBy, startRow, pageSize);

			request.setAttribute("productList", productList);
			request.setAttribute("center", "item/itemShowroom.jsp");

			nextPage = "../pages/defaultMain.jsp";
		}
		/* ############################## modDuteDate.do ############ajax 작업########################################## */
		else if (path.equals("/addCart.do")) { // 장바구니에 상품 추가
			String buyer = (String) session.getAttribute("memberId");
			ItemBean itemBean;

			int itemNo = Integer.parseInt(request.getParameter("itemNo"));
			int itemAmount = Integer.parseInt(request.getParameter("amount"));

			itemBean = new ItemBean(itemNo, itemAmount);

			String[] optNameList = request.getParameterValues("optNames");
			String[] optCostList = request.getParameterValues("optCosts");
			String[] optAmountList = request.getParameterValues("optAmounts");

			JSONArray optArray = new JSONArray();
			if (optNameList != null) {
				for (int i = 0; i < optNameList.length; i++) {
					JSONObject opt = new JSONObject();

					opt.put("optName", optNameList[i]);
					opt.put("optCost", Integer.parseInt(optCostList[i]));
					opt.put("optAmount", Integer.parseInt(optAmountList[i]));

					optArray.add(opt);
				}
			}

			String opts = optArray.toJSONString();

			int result = service.addCart(buyer, itemBean, opts);

			out.print(result);

			return;
		} else if (path.equals("/like.do")) { // 상품 좋아요
			int itemNo = Integer.parseInt(request.getParameter("itemNo"));
			String isHeart = request.getParameter("isHeart");

			int heart = service.likeItem(itemNo, isHeart);

			out.print(heart);
			return;
		} else if (path.equals("/modDuteDate.do")) { // 제작 예정일 수정
			String date = request.getParameter("dueDate");
			int orderno = Integer.parseInt(request.getParameter("orderno"));
			int itemno = Integer.parseInt(request.getParameter("itemno"));

			service.modDuteDate(date, orderno, itemno);

			return;
		} else if (path.equals("/modCart.do")) { // 장바구니 수정			
			String buyer = (String) session.getAttribute("memberId");
			int itemNo = Integer.parseInt(request.getParameter("itemNo"));
			String opts = request.getParameter("opts");

			service.modCart(buyer, itemNo, opts);
			return;
		} else if (path.equals("/addParcel.do")) { //db에 운송장 번호 등록하는 메소드
			//주문번호
			int orderNum = Integer.parseInt(request.getParameter("orderNum"));
			int itemNum = Integer.parseInt(request.getParameter("itemNum"));

			String parcelId = request.getParameter("parcelId"); //택배회사 id
			String wayBill = request.getParameter("wayBill"); //운송장 번호

			service.addParcel(orderNum, itemNum, parcelId, wayBill);

			return; //팝업창에 완료버튼 누르면 바로 창이 닫히고 페이지를 새로고침하는거라 다음페이지가 필요없음

		}
		else if(path.equals("/deleteCart.do")){//장바구니 삭제 메소드
			int[] selectedItemNo = Arrays.stream(request.getParameterValues("itemNo")).mapToInt(Integer::parseInt).toArray();
			String id=(String) session.getAttribute("memberId");
			 service.deleteCart(id,selectedItemNo); 
			return;
		}
		/* ##########################################기타########################################## */
		else if (path.equals("/recomend.do")) {

			String id = (String) session.getAttribute("memberId");
			String auth = (String) session.getAttribute("auth");

			List<ItemBean> styleItemList = service.styleItemList(id, auth);
			
			if(styleItemList.size()>30) {
				styleItemList = styleItemList.subList(0, 30);
			}
			request.setAttribute("styleItemList", styleItemList);

			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "item/recomend.jsp");

		}
		System.out.println("nextPgae : " + nextPage);

		if (nextPage != null) {
			if (isRedirect) {
				System.out.println("리다이렉트 방식");
				response.sendRedirect(nextPage);
			} else {
				System.out.println("디스패치 방식");
				RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
				// 실제 포워딩
				dispatcher.forward(request, response);
			}
		}

	}

	public Map<String, Object> upload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, Object> itemInfo = new HashMap<String, Object>();

		String encoding = "utf-8";

		String realPath = getServletContext().getRealPath("");

		File DirPath = new File(realPath.substring(0, realPath.indexOf(".metadata") - 1) + request.getContextPath() + "\\WebContent\\css\\images\\upload\\itemImg");

		if (!DirPath.exists()) {
			DirPath.mkdirs();
		}

		DiskFileItemFactory factory = new DiskFileItemFactory();

		factory.setSizeThreshold(1024 * 1024 * 1);
		factory.setRepository(DirPath);

		ServletFileUpload upload = new ServletFileUpload(factory);

		try {
			List items = upload.parseRequest(request);

			List<String> style = new ArrayList<String>();
			List<String> optName = new ArrayList<String>();
			List<String> optCost = new ArrayList<String>();

			for (int i = 0; i < items.size(); i++) {
				FileItem item = (FileItem) items.get(i);

				if (item.isFormField()) {
					if (item.getFieldName().equals("style")) {
						style.add(item.getString(encoding));
					} else if (item.getFieldName().equals("OptName")) {
						optName.add(item.getString(encoding));
					} else if (item.getFieldName().equals("OptCost")) {
						optCost.add(item.getString(encoding));
					} else {
						itemInfo.put(item.getFieldName(), item.getString(encoding));
					}

				} else {
					if (item.getSize() > 0) {
						int idx = item.getName().lastIndexOf("\\");

						if (idx == -1) {
							idx = item.getName().lastIndexOf("/");// -1 얻기
						}

						String OrifileName = item.getName().substring(idx + 1);

						File uploadFile = new File(DirPath + "\\" + OrifileName);
						int num = 0;
						String fileName = OrifileName;
						while (uploadFile.exists()) {
							num++;
							System.out.println("파일 중복");
							fileName = OrifileName.substring(0, OrifileName.indexOf(".")) + "Ver" + num + OrifileName.substring(OrifileName.indexOf("."));
							uploadFile = new File(DirPath + "\\" + fileName);
						}
						item.write(uploadFile);

						itemInfo.put(item.getFieldName(), fileName);
					}

				}
			}
			itemInfo.put("style", style);
			itemInfo.put("optName", optName);
			itemInfo.put("optCost", optCost);

		} catch (Exception e) {
			System.out.println("upload 메서드에서 에러 : " + e);
		}

		return itemInfo;
	}
}
