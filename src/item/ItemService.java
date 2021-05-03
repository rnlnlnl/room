package item;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import bean.ItemBean;
import bean.OrderBean;
import bean.OrderItemBean;

public class ItemService {

	ItemDAO iDAO;

	public ItemService() {
		// 객체 생성시 자동으로 dao 객체 생성
		iDAO = new ItemDAO();
	}

	public void addItem(Map<String, Object> itemInfo) {
		iDAO.addItem(itemInfo);

	}

	public ArrayList<ItemBean> listItem(String seller) {
		ArrayList<ItemBean> itemList = iDAO.listItem(seller);

		return itemList;
	}

	public Map readItem(int itemNo) {
		Map itemInfo = iDAO.readItem(itemNo);

		return itemInfo;
	}

	public void chageItemState(int itemNo) {
		iDAO.chageItemState(itemNo);
	}

	public void modItem(Map<String, Object> modItemInfo) {
		iDAO.modItem(modItemInfo);

	}

	public ArrayList<ItemBean> productList(String itemCate, String colorFilter, String styleFilter, int minAge, int maxAge, String sortBy, int startRow, int pageSize) {
		ArrayList<ItemBean> productList = iDAO.productList(itemCate, colorFilter, styleFilter, minAge, maxAge, sortBy, startRow, pageSize);
		return productList;
	}

	public int addCart(String buyer, ItemBean itemBean, String opts) {
		int result = iDAO.addCart(buyer, itemBean, opts);
		return result;
	}

	public List listOrder(String id, String auth) {
		List<OrderBean> orderList = iDAO.orderList(id, auth);
		return orderList;
	}

	public List cartList(String buyer) {
		List cartList = iDAO.cartList(buyer);

		return cartList;
	}

	public int likeItem(int itemNo, String isHeart) {
		int haert = iDAO.likeItem(itemNo, isHeart);
		return haert;
	}

	public Map<String, Object> search(String searchText) {
		Map<String, Object> searchMap = iDAO.search(searchText);
		return searchMap;
	}

	public List<ItemBean> styleItemList(String id, String auth) {
		List<ItemBean> styleItemList = iDAO.styleItemList(id, auth);
		return styleItemList;
	}

	public List<Map<String, Object>> orderItemList(int orderNo) {
		List<Map<String, Object>> orderItemList = iDAO.readOrder(orderNo);
		return orderItemList;
	}

	public void modCart(String buyer, int itemNo, String opts) {
		iDAO.modCart(buyer, itemNo, opts);
	}

	public List getOptList(int itemNo) {
		Map itemInfo = iDAO.readItem(itemNo);
		List optList = (List) itemInfo.get("options");
		return optList;
	}

	public Map<String, Object> readCartItem(String buyer, int itemNo) {
		List cartList = iDAO.cartList(buyer);

		Map<String, Object> cartItem = null;

		for (int i = 0; i < cartList.size(); i++) {
			cartItem = (Map<String, Object>) cartList.get(i);
			ItemBean itemBean = (ItemBean) cartItem.get("itemBean");
			if (itemBean.getItemno() == itemNo) {
				break;
			}
		}
		return cartItem;
	}

	public List<Map<String, Object>> selectedItemList(String buyer, int[] selectedItemNo) {
		List<Map<String, Object>> selectedItemList = new ArrayList<Map<String, Object>>();

		List<Map<String, Object>> cartList = iDAO.cartList(buyer);

		for (int i = 0; i < cartList.size(); i++) {
			Map<String, Object> cartItem = (Map<String, Object>) cartList.get(i);
			ItemBean itemBean = (ItemBean) cartItem.get("itemBean");

			for (int j = 0; j < selectedItemNo.length; j++) {
				if (itemBean.getItemno() == selectedItemNo[j]) {
					selectedItemList.add(cartItem);
				}
			}
		}

		return selectedItemList;
	}

	public ItemBean getItemInfo(int itemNo) {
		Map item = iDAO.readItem(itemNo);
		return (ItemBean) item.get("itemBean");
	}

	public int countItem(String itemCate, String colorFilter, String styleFilter, int minAge, int maxAge) {
		return iDAO.countItem(itemCate, colorFilter, styleFilter, minAge, maxAge);
	}

	public void addOrder(OrderBean orderBean, List<OrderItemBean> orderItemList) {
		iDAO.addOrder(orderBean, orderItemList);

	}

	public List<Map<String, Object>> listSoldItem(String seller) {
		List<Map<String, Object>> listSoldItem = iDAO.listSoldItem(seller);
		return listSoldItem;
	}

	public void modDuteDate(String date, int orderno, int itemno) {
		iDAO.modDuteDate(date, orderno, itemno);
	}

	public void addParcel(int orderNum, int itemNum, String parcelId, String wayBill) {
		iDAO.addParcel(orderNum, itemNum, parcelId, wayBill);

	}

	public Map filterMap() {
		Map filterMap = iDAO.filterMap();
		return filterMap;
	}

	public void deleteCart(String id, int[] arr) { //2월 13일 장바구니 삭제 메소드
		for (int i = 0; i < arr.length; i++)
			iDAO.deleteCart(id, arr[i]);
		return;
	}

	/* ###################################DAO가지 않는 서비스 작업############################################## */

}
