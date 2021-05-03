package item;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import javax.websocket.CloseReason;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import bean.BoardBean;
import bean.CartBean;
import bean.ItemBean;
import bean.OptionBean;
import bean.OrderBean;
import bean.OrderItemBean;

@SuppressWarnings("rawtypes") /* Map, List 타입 설정 안 했을 시 경고 무시 해주는 어노테이션 */
public class ItemDAO {

	Connection conn = null;
	PreparedStatement pst = null;
	ResultSet res = null;
	DataSource ds = null;

	String sql;

	// 커넥션풀 얻는 메소드
	private Connection getConnection() throws Exception {
		Connection conn = null;
		Context init = new InitialContext();

		DataSource ds = (DataSource) init.lookup("java:comp/env/jdbc/roomdy");

		// 커넥션풀 얻기
		conn = ds.getConnection();

		return conn;

	}// getConnection()메서드 끝

	// 자원 반납메소드 입니다 한번에 close할수있는데 없는 항목은 null로 쓰면 됩니다
	private void closeAll(Connection c, PreparedStatement p, ResultSet r) {
		try {
			if (c != null)
				c.close();
			if (p != null)
				p.close();
			if (r != null)
				r.close();
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("자원 반납중 에러");
		}
	}// closeAll()메소드 끝

	public void addItem(Map<String, Object> itemInfo) { // 상품등록(판매자가 상품을 등록하는 단계)
		ItemBean itemBean = null;
		List<OptionBean> options = new ArrayList<OptionBean>();

		try {
			int ItemNo = getItemNo();

			sql = "INSERT INTO dyitem(itemNo, cost,seller,itemName,itemCate,itemColor,preferage,style,amount,itemImg, dueDate) VALUES(?,?,?,?,?,?,?,?,?,?, ?)";

			pst = conn.prepareStatement(sql);

			itemBean = (ItemBean) itemInfo.get("itemBean");
			options = (List<OptionBean>) itemInfo.get("options");

			pst.setInt(1, ItemNo);
			pst.setInt(2, itemBean.getCost());
			pst.setString(3, itemBean.getSeller());
			pst.setString(4, itemBean.getItemname());
			pst.setString(5, itemBean.getItemCate());
			pst.setString(6, itemBean.getItemColor());
			pst.setInt(7, itemBean.getPreferage());
			pst.setString(8, itemBean.getStyle());
			pst.setInt(9, itemBean.getAmount());
			pst.setString(10, itemBean.getItemImg());
			pst.setInt(11, itemBean.getDueDate());

			pst.executeUpdate();

			for (int i = 0; i < options.size(); i++) {
				OptionBean option = options.get(i);
				int OptionNo = getOptionNo(ItemNo);

				sql = "INSERT INTO dyoption(itemNo, optNo, optName, optCost) VALUES(?,?,?,?)";

				pst = conn.prepareStatement(sql);

				pst.setInt(1, ItemNo);
				pst.setInt(2, OptionNo);
				pst.setString(3, option.getOptName());
				pst.setInt(4, option.getOptCost());

				pst.executeUpdate();
			}

		} catch (Exception e) {

			System.out.println("ItemDAO : addItem(상품 추가)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}
	}// addItem()메소드 끝

	public void modItem(Map<String, Object> modItemInfo) { // 상품수정(판매자가 상품에 대한 정보를 수정)
		ItemBean itemBean = (ItemBean) modItemInfo.get("itemBean");

		List<OptionBean> options = (List<OptionBean>) modItemInfo.get("options");

		try {
			conn = getConnection();

			sql = "delete from dyoption where itemno = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, itemBean.getItemno());

			pst.executeUpdate();

			sql = "UPDATE dyitem SET cost = ?, itemName = ?, itemCate = ?, itemColor = ?, preferage = ?, style = ?, amount = ? WHERE itemNo = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, itemBean.getCost());
			pst.setString(2, itemBean.getItemname());
			pst.setString(3, itemBean.getItemCate());
			pst.setString(4, itemBean.getItemColor());
			pst.setInt(5, itemBean.getPreferage());
			pst.setString(6, itemBean.getStyle());
			pst.setInt(7, itemBean.getAmount());
			pst.setInt(8, itemBean.getItemno());

			pst.executeUpdate();

			if (itemBean.getItemImg() != "") {
				sql = "UPDATE dyitem SET itemImg = ? WHERE itemNo = ?";

				pst = conn.prepareStatement(sql);

				pst.setString(1, itemBean.getItemImg());
				pst.setInt(2, itemBean.getItemno());

				pst.executeUpdate();
			}

			for (int i = 0; i < options.size(); i++) {
				OptionBean option = options.get(i);
				int OptionNo = getOptionNo(itemBean.getItemno());

				sql = "INSERT INTO dyoption(itemNo, optNo, optName, optCost) VALUES(?,?,?,?)";

				pst = conn.prepareStatement(sql);

				pst.setInt(1, itemBean.getItemno());
				pst.setInt(2, OptionNo);
				pst.setString(3, option.getOptName());
				pst.setInt(4, option.getOptCost());

				pst.executeUpdate();
			}

		} catch (Exception e) {

			System.out.println("ItemDAO : addItem(상품 추가)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}
	}// modItem()메소드 끝

	public ArrayList<ItemBean> listItem(String seller) {
		ArrayList<ItemBean> itemList = new ArrayList<ItemBean>();
		try {
			conn = getConnection();

			sql = "SELECT * FROM dyitem";

			if (!seller.equals("admin"))
				sql += " WHERE seller = ?";

			sql += " order by isuse desc, itemNo desc";

			pst = conn.prepareStatement(sql);

			if (!seller.equals("admin"))
				pst.setString(1, seller);

			res = pst.executeQuery();

			while (res.next()) {
				ItemBean itemBean = new ItemBean(res.getBoolean("isuse"), res.getInt("itemNo"), res.getInt("cost"), res.getInt("amount"), res.getString("itemName"), res.getString("itemCate"), res.getString("itemImg"), res.getInt("heart"));

				itemBean.setSeller(res.getString("seller"));

				itemList.add(itemBean);
			}

		} catch (Exception e) {

			System.out.println("itemDAO : listItem(상품 목록 가져오는 작업)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}
		return itemList;
	}// listItem()메소드 끝

	public int getItemNo() {
		int result = 0;
		try {
			conn = getConnection();

			sql = "SELECT max(itemNo) FROM dyitem";

			pst = conn.prepareStatement(sql);

			res = pst.executeQuery();

			if (res.next()) {
				result = res.getInt(1) + 1;
			}

		} catch (Exception e) {

			System.out.println("itemDAO : getItemNo(상품 추가시 상품 번호 가져오기)에서 에러" + e);
		}

		return result;
	}

	public int getOptionNo(int itemNo) {
		int result = 0;
		try {
			sql = "SELECT max(optNo) FROM dyoption where itemNo = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, itemNo);

			res = pst.executeQuery();

			if (res.next()) {
				result = res.getInt(1) + 1;
			}

		} catch (Exception e) {

			System.out.println("itemDAO : getOptionNo에서 에러" + e);
		}

		return result;
	}

	public Map readItem(int itemNo) { //상품 1개 상세보기 페이지 입니다.

		Map itemInfo = new HashMap();

		ItemBean itemBean = new ItemBean();
		List<OptionBean> options = new ArrayList<OptionBean>();

		try {
			conn = getConnection();
			sql = "SELECT * FROM dyitem WHERE itemNo = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, itemNo);

			res = pst.executeQuery();

			if (res.next()) {
				itemBean.setSeller(res.getString("seller"));
				itemBean.setCost(res.getInt("cost"));
				itemBean.setPreferage(res.getInt("preferage"));
				itemBean.setHeart(res.getInt("heart"));
				itemBean.setAmount(res.getInt("amount"));
				itemBean.setSeller(res.getString("seller"));
				itemBean.setItemname(res.getString("itemName"));
				itemBean.setItemCate(res.getString("itemCate"));
				itemBean.setItemColor(res.getString("itemColor"));
				itemBean.setStyle(res.getString("style"));
				itemBean.setItemImg(res.getString("itemImg"));
				itemBean.setItemno(itemNo);
				itemBean.setIsUse(res.getBoolean("isuse"));
				itemBean.setDueDate(res.getInt("dueDate"));

				sql = "SELECT * FROM dyoption WHERE itemNo = ?";

				pst = conn.prepareStatement(sql);

				pst.setInt(1, itemNo);

				ResultSet res2 = pst.executeQuery();

				while (res2.next()) {
					int optNO = res2.getInt("optNo");
					String optName = res2.getString("optName");
					int optCost = res2.getInt("optCost");

					OptionBean option = new OptionBean(optNO, optCost, optName);

					options.add(option);
				}
			}

			itemInfo.put("itemBean", itemBean);
			itemInfo.put("options", options);
		} catch (Exception e) {

			System.out.println("itemDAO : readItem(상품 목록 가져오는 작업)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}
		return itemInfo;
	}

	public void chageItemState(int itemNo) { // 상품 중지 및 재개 설정

		try {
			conn = getConnection();

			sql = "select isuse from dyitem where itemNo = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, itemNo);

			res = pst.executeQuery();

			boolean isuse = false;

			if (res.next()) {
				isuse = !res.getBoolean(1);
			}

			sql = "update dyitem set isuse = ? where itemNo =?";

			pst = conn.prepareStatement(sql);

			pst.setBoolean(1, isuse);
			pst.setInt(2, itemNo);

			pst.executeUpdate();
		} catch (Exception e) {

			System.out.println("itemDAO : chageItemState(상품 상태 변경)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}
	}// chageItemState()메소드 끝

	public void addOrder(OrderBean orderBean, List<OrderItemBean> orderItemList) { // 주문등록(구매자가 결제 정보를 등록하는 단계)
		try {
			conn = getConnection();

			int orderNo = getOrderNO();

			sql = "INSERT INTO dyorder (orderNo, orderer, recipient, reczipcode, recaddr1, recaddr2, recphone) VALUES (?,?,?,?,?,?,?)";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, orderNo);
			pst.setString(2, orderBean.getOrderer());
			pst.setString(3, orderBean.getRecipient());
			pst.setInt(4, orderBean.getReczipcode());
			pst.setString(5, orderBean.getRecaddr1());
			pst.setString(6, orderBean.getRecaddr2());
			pst.setString(7, orderBean.getRecphone());

			pst.execute();

			for (int i = 0; i < orderItemList.size(); i++) {
				OrderItemBean orderItemBean = orderItemList.get(i);
				int reqDate = 0;

				sql = "select dueDate, seller from dyitem where itemno = ?";

				pst = conn.prepareStatement(sql);

				pst.setInt(1, orderItemBean.getItemno());

				res = pst.executeQuery();

				if (res.next()) {
					orderItemBean.setSeller(res.getString("seller"));
					reqDate = res.getInt("dueDate");
				}
				/* ============제작 예정일 계산하기================== */
				//오늘 날짜 + item db에 저장된(아이템 등록할 때 등록해둔) 제작 소요일
				Calendar now = Calendar.getInstance();
				now.add(Calendar.DATE, reqDate);

				DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				/* ============제작 예정일 계산하기 끝================== */

				sql = "INSERT INTO dyorderitem (orderNo, itemNo, orderAmount, orderopt, seller, dueDate) VALUES (?,?,?,?,?,?)";

				pst = conn.prepareStatement(sql);

				pst.setInt(1, orderNo);
				pst.setInt(2, orderItemBean.getItemno());
				pst.setInt(3, orderItemBean.getOrderamount());
				pst.setString(4, orderItemBean.getOrderOpt());
				pst.setString(5, orderItemBean.getSeller());
				pst.setString(6, df.format(now.getTime()));

				pst.execute();
			}

		} catch (Exception e) {
			System.out.println("ItemDAO : addOrder(주문 등록)에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, null);
		}
	}// addOrder()메소드 끝

	public int addCart(String buyer, ItemBean itemBean, String opts) {
		int result = 0;
		/*
		 * -1 해당 상품이 이미 장바구니에 담겨져있음 0 에러 1 상품 담음
		 */

		try {
			conn = getConnection();

			int orderNo = getOrderNO();

			sql = "select * from dycart where id = ? and itemno = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, buyer);
			pst.setInt(2, itemBean.getItemno());

			res = pst.executeQuery();

			if (res.next()) {
				result = -1; //장바구니에 해당 상품이 있다고 알림
			}
			else {
				sql = "INSERT INTO dycart(id,itemNo,cartamount,cartopt) VALUES (?, ?, ?, ?)";

				pst = conn.prepareStatement(sql);

				pst.setString(1, buyer);
				pst.setInt(2, itemBean.getItemno());
				pst.setInt(3, itemBean.getAmount());
				pst.setString(4, opts);

				pst.executeUpdate();

				result++;
			}
		} catch (Exception e) {
			System.out.println("ItemDAO : addCart(장바구니 추가)에서 에러" + e);
			e.printStackTrace();
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return result;
	}

	public int getOrderNO() { //주문번호 생성 하는 메서드
		int orderNo = 0;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String orderDate = sdf.format(new Date());

		try {
			sql = "select max(orderNo%100) from dyorder where orderNo like ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, orderDate.substring(0, 8) + "%");

			res = pst.executeQuery();

			if (res.next()) {
				orderDate = orderDate + String.format("%02d", res.getInt(1));
			}

			orderNo = Integer.parseInt(orderDate) + 1;

		} catch (Exception e) {

			System.out.println("itemDAO : getItemNo(상품 추가시 상품 번호 가져오기)에서 에러" + e);
		}

		return orderNo;
	}

	public List cartList(String buyer) {
		List cartList = new ArrayList();

		ItemBean itemBean;
		CartBean cartBean;
		List optList;

		Map<String, Object> cart;
		try {
			conn = getConnection();

			sql = "select * from dycart join dyitem on dycart.itemNo = dyitem.itemNO where id = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, buyer);

			res = pst.executeQuery();

			while (res.next()) {
				itemBean = new ItemBean();
				cartBean = new CartBean();
				optList = new ArrayList();

				cart = new HashMap<String, Object>();

				itemBean.setItemname(res.getString("itemName"));
				itemBean.setSeller(res.getString("seller"));
				cartBean.setCartamount(res.getInt("cartamount"));
				itemBean.setItemno(res.getInt("itemNo"));
				itemBean.setCost(res.getInt("cost"));
				itemBean.setItemImg(res.getString("itemImg"));
				/* =============================json 파싱================================ */
				JSONParser jsonParser = new JSONParser();

				JSONArray jsonArry = (JSONArray) jsonParser.parse(res.getString("cartOpt"));

				for (int i = 0; i < jsonArry.size(); i++) {
					JSONObject jsonObj2 = (JSONObject) jsonArry.get(i);

					optList.add(jsonObj2);
				}

				cart.put("itemBean", itemBean);
				cart.put("cartBean", cartBean);
				cart.put("optList", optList);

				cartList.add(cart);
			}

		} catch (Exception e) {

			System.out.println("itemDAO : cartList(장바구니 목록 가져오는 작업)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}
		return cartList;
	}

	public int likeItem(int itemNo, String isHeart) {
		int heart = 0;

		try {
			conn = getConnection();

			sql = "UPDATE dyitem SET heart = heart";

			if (isHeart.equals("true")) {
				sql += "-";
			}
			else {
				sql += "+";
			}
			sql += "1 where itemNo = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, itemNo);
			pst.executeUpdate();

			sql = "select heart from dyitem where itemNo = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, itemNo);

			res = pst.executeQuery();

			if (res.next()) {
				heart = res.getInt(1);
			}

		} catch (Exception e) {

			System.out.println("ItemDAO : likeItem(상품 좋아요)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return heart;
	}

	public Map<String, Object> search(String searchText) {

		Map<String, Object> searchMap = new HashMap<String, Object>();

		try {
			conn = getConnection();

			List<ItemBean> itemList = new ArrayList<ItemBean>();

			sql = "select * from dyitem where itemname like ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, "%" + searchText + "%");

			res = pst.executeQuery();

			while (res.next()) {
				ItemBean itemBean = new ItemBean();

				itemBean.setItemno(res.getInt("itemNo"));
				itemBean.setCost(res.getInt("cost"));
				itemBean.setSeller(res.getString("seller"));
				itemBean.setItemname(res.getString("itemname"));
				itemBean.setItemImg(res.getString("itemImg"));

				itemList.add(itemBean);
			}

			List<BoardBean> boardList = new ArrayList<BoardBean>();

			sql = "select * from dyboard where title like ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, "%" + searchText + "%");

			res = pst.executeQuery();

			while (res.next()) {
				BoardBean boardBean = new BoardBean();

				boardBean.setPostno(res.getInt("postNo"));
				boardBean.setPostcate(res.getString("postCate"));
				boardBean.setTitle(res.getString("title"));
				boardBean.setWriter(res.getString("writer"));

				boardList.add(boardBean);
			}

			searchMap.put("itemList", itemList);
			searchMap.put("boardList", boardList);
		} catch (Exception e) {

			System.out.println("ItemDAO : search(검색)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return searchMap;
	}

	public List<ItemBean> styleItemList(String id, String auth) {
		List<ItemBean> styleItemList = new ArrayList<ItemBean>();

		try {
			conn = getConnection();

			if (auth == null) {
				sql = "select itemno, seller, itemImg, itemName, cost from dyitem order by heart limit 0, 30";

				pst = conn.prepareStatement(sql);
			}
			else {
				sql = "select b.itemno, b.seller, b.itemImg, b.itemName, b.cost from dyitem b join dymember i on b.style = i.style where i.id=? order by heart limit 0,30";

				pst = conn.prepareStatement(sql);

				pst.setString(1, id);
			}

			res = pst.executeQuery();

			while (res.next()) {
				ItemBean itemBean = new ItemBean();

				itemBean.setItemno(res.getInt("itemNo"));
				itemBean.setCost(res.getInt("cost"));
				itemBean.setSeller(res.getString("seller"));
				itemBean.setItemname(res.getString("itemname"));
				itemBean.setItemImg(res.getString("itemImg"));

				styleItemList.add(itemBean);
			}
		} catch (Exception e) {

			System.out.println("ItemDAO : search(검색)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return styleItemList;
	}

	public List<OrderBean> orderList(String id, String auth) {
		List<OrderBean> listOrder = new ArrayList<OrderBean>();

		try {
			conn = getConnection();

			if (auth.equals("A") || auth.equals("a")) {

				sql = "select * from dyorder";

				pst = conn.prepareStatement(sql);

				res = pst.executeQuery();
			}

			else {
				if (auth.equals("s") || auth.equals("S")) {
					sql = "select dyorder.orderno, orderer, orderDate from dyorder join dyorderitem on dyorder.orderno = dyorderitem.orderno where seller = ?";
				}
				else {
					sql = "select * from dyorder where orderer = ?";
				}

				sql += "order by orderDate desc";

				pst = conn.prepareStatement(sql);

				pst.setString(1, id);

				res = pst.executeQuery();
			}

			while (res.next()) {
				OrderBean orderBean = new OrderBean();

				orderBean.setOrderno(res.getInt("orderno"));
				orderBean.setOrderer(res.getString("orderer"));
				orderBean.setOrderdate(res.getTimestamp("orderDate"));

				listOrder.add(orderBean);
			}
		} catch (Exception e) {

			System.out.println("ItemDAO : orderList(검색)에서 에러" + e);
			e.printStackTrace();
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return listOrder;
	}

	public List<Map<String, Object>> readOrder(int orderNo) { // 주문 상세보기(결제 완료 후 상품 단계-상품 제작과정 단계 및 배송조회 )
		List<Map<String, Object>> orderItemList = new ArrayList<Map<String, Object>>();

		try {
			conn = getConnection();

			sql = "SELECT dyorder.orderno, dyitem.itemno,waybill ,parcel, itemname, cost, TIMESTAMPDIFF(DAY, orderDate, SYSDATE()) daysfromorder, TIMESTAMPDIFF(DAY, orderdate, dyorderitem.dueDate) periodproduce, shipProc, orderAmount, dyorderitem.dueDate, orderopt, reviewNo " + "FROM dyorderitem " + "JOIN dyorder ON dyorder.orderno = dyorderitem.orderno " + "JOIN dyitem ON dyorderitem.itemNo = dyitem.itemno " + "where dyorder.orderno = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, orderNo);

			res = pst.executeQuery();

			while (res.next()) {
				Map<String, Object> orderMap = new HashMap<String, Object>();

				OrderItemBean orderItemBean = new OrderItemBean();
				ItemBean itemBean = new ItemBean();

				orderItemBean.setOrderno(res.getInt("orderno"));
				itemBean.setItemname(res.getString("itemname"));
				itemBean.setCost(res.getInt("cost"));
				itemBean.setItemno(res.getInt("itemno"));

				int daysfromorder = res.getInt("daysfromorder");
				int periodproduce = res.getInt("periodproduce");

				orderItemBean.setManuProc(daysfromorder * 100 / periodproduce);
				orderItemBean.setShipProc(res.getString("shipProc"));
				orderItemBean.setOrderamount(res.getInt("orderAmount"));
				orderItemBean.setDueDate(res.getTimestamp("dueDate"));
				orderItemBean.setOrderOpt(res.getString("orderopt"));
				orderItemBean.setReviewNo(res.getInt("reviewNo"));
				orderItemBean.setWaybill(res.getString("waybill"));
				orderItemBean.setParcel(res.getString("parcel"));

				orderMap.put("orderItemBean", orderItemBean);
				orderMap.put("itemBean", itemBean);

				orderItemList.add(orderMap);
			}
		} catch (Exception e) {

			System.out.println("ItemDAO : readOrder(주문목록 상세보기)에서 에러" + e);
			e.printStackTrace();
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return orderItemList;
	}// readOrder()메소드 끝

	public void modCart(String buyer, int itemNo, String opts) { // 장바구니 수정
		try {
			conn = getConnection();

			Calendar now = Calendar.getInstance();

			sql = "UPdate dycart set cartopt = ? where id=? and itemno =?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, opts);
			pst.setString(2, buyer);
			pst.setInt(3, itemNo);

			pst.executeUpdate();
		} catch (Exception e) {
			System.out.println("ItemDAO : modCart(장바구니 수정)에서 에러" + e);
			e.printStackTrace();
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}
	}// modCart()메소드 끝

	public int countItem(String itemCate, String colorFilter, String styleFilter, int minAge, int maxAge) {
		int count = 0;

		try {
			conn = getConnection();

			sql = "SELECT count(*) FROM dyitem WHERE isuse = 1 AND preferage between ? and ?";

			if (itemCate != null && itemCate != "")
				sql += " and itemCate = ?";

			if (colorFilter != null && colorFilter != "")
				sql += " and itemColor = ?";

			if (styleFilter != null && styleFilter != "")
				sql += " and style = ?";

			pst = conn.prepareStatement(sql);

			int pstNo = 1;

			pst.setInt(pstNo++, minAge);
			pst.setInt(pstNo++, maxAge);

			if (itemCate != null && itemCate != "")
				pst.setString(pstNo++, itemCate);

			if (colorFilter != null && colorFilter != "")
				pst.setString(pstNo++, colorFilter);

			if (styleFilter != null && styleFilter != "")
				pst.setString(pstNo++, styleFilter);

			res = pst.executeQuery();

			if (res.next()) {
				count = res.getInt(1);
			}

		} catch (Exception e) {

			System.out.println("itemDAO : countItem(상품 개수)에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}
		return count;
	}

	public List<Map<String, Object>> listSoldItem(String seller) {
		List<Map<String, Object>> listSoldItem = new ArrayList<Map<String, Object>>();

		try {
			conn = getConnection();
			if (seller.equals("admin")) {
				sql = "SELECT dyitem.seller, orderDate,orderer, dyorder.orderno, dyitem.itemno, itemname, TIMESTAMPDIFF(DAY, orderDate, SYSDATE()) daysfromorder, TIMESTAMPDIFF(DAY, orderdate, dyorderitem.dueDate) periodproduce, shipProc, orderAmount, dyorderitem.dueDate, orderopt, reviewNo " + "FROM dyorderitem " + "JOIN dyorder ON dyorder.orderno = dyorderitem.orderno " + "JOIN dyitem ON dyorderitem.itemNo = dyitem.itemno order by orderDate desc";

				pst = conn.prepareStatement(sql);
			}
			else {
				sql = "SELECT dyitem.seller, orderDate,orderer, dyorder.orderno, dyitem.itemno, itemname, TIMESTAMPDIFF(DAY, orderDate, SYSDATE()) daysfromorder, TIMESTAMPDIFF(DAY, orderdate, dyorderitem.dueDate) periodproduce, shipProc, orderAmount, dyorderitem.dueDate, orderopt, reviewNo " + "FROM dyorderitem " + "JOIN dyorder ON dyorder.orderno = dyorderitem.orderno " + "JOIN dyitem ON dyorderitem.itemNo = dyitem.itemno " + "where dyorderitem.seller = ? " + "order by orderDate desc";

				pst = conn.prepareStatement(sql);

				pst.setString(1, seller);
			}

			res = pst.executeQuery();

			while (res.next()) {
				Map<String, Object> orderMap = new HashMap<String, Object>();

				OrderBean orderBean = new OrderBean();
				OrderItemBean orderItemBean = new OrderItemBean();
				ItemBean itemBean = new ItemBean();

				int daysfromorder = res.getInt("daysfromorder");//주문한 날짜부터 현재 날짜까지
				int periodproduce = res.getInt("periodproduce");//주문날부터 제작일까지

				orderBean.setOrderno(res.getInt("orderno"));
				orderBean.setOrderer(res.getString("orderer"));
				itemBean.setItemname(res.getString("itemname"));
				itemBean.setSeller(res.getString("seller"));
				orderItemBean.setOrderamount(res.getInt("orderAmount"));
				orderItemBean.setManuProc(daysfromorder * 100 / periodproduce);
				orderBean.setOrderdate(res.getTimestamp("orderDate"));
				itemBean.setItemno(res.getInt("itemno"));
				orderItemBean.setShipProc(res.getString("shipProc"));
				orderItemBean.setDueDate(res.getTimestamp("dueDate"));
				orderItemBean.setOrderOpt(res.getString("orderopt"));
				orderItemBean.setReviewNo(res.getInt("reviewNo"));

				orderMap.put("orderBean", orderBean);
				orderMap.put("orderItemBean", orderItemBean);
				orderMap.put("itemBean", itemBean);

				listSoldItem.add(orderMap);
			}
		} catch (Exception e) {

			System.out.println("ItemDAO : readOrder(주문목록 상세보기)에서 에러" + e);
			e.printStackTrace();
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return listSoldItem;
	}

	public void modDuteDate(String date, int orderno, int itemno) {
		try {
			conn = getConnection();

			sql = "UPDATE dyorderitem SET dueDate = ? WHERE (orderNo = ?) and (itemNo = ?)";

			pst = conn.prepareStatement(sql);

			pst.setString(1, date);
			pst.setInt(2, orderno);
			pst.setInt(3, itemno);

			pst.execute();
		} catch (Exception e) {

			System.out.println("itemDAO : modDuteDate(제작 예정일 수정)에서 에러" + e);
		}

	}

	public void addParcel(int orderNum, int itemNum, String parcelId, String wayBill) {
		try {
			conn = getConnection();

			sql = "update dyorderitem set parcel=?,waybill=?,shipproc='발송완료' where orderno=? and itemno=?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, parcelId);
			pst.setString(2, wayBill);
			pst.setInt(3, orderNum);
			pst.setInt(4, itemNum);

			pst.execute();
		} catch (Exception e) {

			System.out.println("itemDAO : addParcel(운송장 등록)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

	}

	/* ================================================================================================================= */

	public void delCart() { // 장바구니 삭제(담아놓은 상품 삭제)

	}// delCart()메소드 끝

	public Map filterMap() {
		Map filterMap = new HashMap();

		List colorFilter = new ArrayList();
		List styleFilter = new ArrayList();

		try {
			conn = getConnection();

			sql = "select DISTINCT itemcolor from dyitem";

			pst = conn.prepareStatement(sql);

			res = pst.executeQuery();

			while (res.next()) {
				colorFilter.add(res.getString(1));
			}

			sql = "select DISTINCT style from dyitem";

			pst = conn.prepareStatement(sql);

			res = pst.executeQuery();

			while (res.next()) {
				styleFilter.add(res.getString(1));
			}

			filterMap.put("colorFilter", colorFilter);
			filterMap.put("styleFilter", styleFilter);
		} catch (Exception e) {

			System.out.println("itemDAO : filterMap(필터 목록 받아오기)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}
		return filterMap;
	}

	public ArrayList<ItemBean> productList(String itemCate, String colorFilter, String styleFilter, int minAge, int maxAge, String sortBy, int startRow, int pageSize) { //판매하는 상품 조회 메서드
		ArrayList<ItemBean> productList = new ArrayList<ItemBean>();

		try {
			conn = getConnection();

			String sql;

			sql = "SELECT * FROM dyitem " + "WHERE isuse = 1 AND preferage BETWEEN ? and ?";

			if (itemCate != null && !itemCate.equals(""))
				sql += " AND itemCate = ?";

			if (colorFilter != null && !colorFilter.equals(""))
				sql += " AND itemColor = ?";

			if (styleFilter != null && !styleFilter.equals(""))
				sql += " AND style = ?";

			sql += " ORDER BY " + sortBy + " LIMIT ?, ?";

			pst = conn.prepareStatement(sql);

			int pstNo = 1;

			pst.setInt(pstNo++, minAge);
			pst.setInt(pstNo++, maxAge);

			if (itemCate != null && !itemCate.equals(""))
				pst.setString(pstNo++, itemCate);

			if (colorFilter != null && !colorFilter.equals(""))
				pst.setString(pstNo++, colorFilter);

			if (styleFilter != null && !styleFilter.equals(""))
				pst.setString(pstNo++, styleFilter);

			pst.setInt(pstNo++, startRow);
			pst.setInt(pstNo++, pageSize);

			res = pst.executeQuery();

			while (res.next()) {
				ItemBean itemBean = new ItemBean();
				itemBean.setItemno(res.getInt("itemno"));
				itemBean.setCost(res.getInt("cost"));
				itemBean.setItemname(res.getString("itemName"));
				itemBean.setItemCate(res.getString("itemCate"));
				itemBean.setItemImg(res.getString("itemImg"));
				itemBean.setHeart(res.getInt("heart"));
				itemBean.setSeller(res.getString("seller"));
				itemBean.setItemColor(res.getString("itemColor"));
				itemBean.setPreferage(res.getInt("preferage"));
				itemBean.setStyle(res.getString("style"));

				productList.add(itemBean);
			}

		} catch (Exception e) {
			System.out.println("itemDAO : productList(상품 목록 가져오는 작업)에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}
		return productList;
	}

	public ArrayList<ItemBean> productList_ori(String itemCate, String sortBy, int startRow, int pageSize) { //판매하는 상품 조회 메서드
		ArrayList<ItemBean> productList = new ArrayList<ItemBean>();

		try {
			conn = getConnection();

			sql = "SELECT * FROM dyitem WHERE isuse = 1";

			if (itemCate != null && itemCate != "") {
				sql += " and itemCate = ?";
			}

			sql += " order by " + sortBy + " limit ?, ?";

			pst = conn.prepareStatement(sql);

			if (itemCate != null && itemCate != "") {
				pst.setString(1, itemCate);
				pst.setInt(2, startRow);
				pst.setInt(3, pageSize);
			}
			else {
				pst.setInt(1, startRow);
				pst.setInt(2, pageSize);
			}

			res = pst.executeQuery();

			while (res.next()) {
				ItemBean itemBean = new ItemBean();
				itemBean.setItemno(res.getInt("itemno"));
				itemBean.setCost(res.getInt("cost"));
				itemBean.setItemname(res.getString("itemName"));
				itemBean.setItemCate(res.getString("itemCate"));
				itemBean.setItemImg(res.getString("itemImg"));
				itemBean.setHeart(res.getInt("heart"));
				itemBean.setSeller(res.getString("seller"));

				productList.add(itemBean);
			}

		} catch (Exception e) {

			System.out.println("itemDAO : productList(상품 목록 가져오는 작업)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}
		return productList;
	}

	public void deleteCart(String id, int i) {
		sql = "delete from dycart where id=? and itemno=?";

		try {
			conn = getConnection();
			pst = conn.prepareStatement(sql);
			pst.setString(1, id);
			pst.setInt(2, i);
			pst.executeUpdate();

			closeAll(conn, pst, null);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("장바구니 삭제중 에러");
		}

	}

} // ItemDAO()메소드 끝
