package bean;

import java.sql.Timestamp;

public class OrderItemBean {

	private int orderno;
	private int itemno;
	private int manuProc;
	private String shipProc;
	private int orderamount;
	private Timestamp dueDate;
	private String orderOpt;
	private String seller;
	private String parcel;
	private int reviewNo;
	private String waybill;

	public String getWaybill() {
		return waybill;
	}

	public void setWaybill(String waybill) {
		this.waybill = waybill;
	}

	public OrderItemBean(int orderno, int itemno, int manuProc, String shipProc, int orderamount, Timestamp dueDate) {
		this.orderno = orderno;
		this.itemno = itemno;
		this.manuProc = manuProc;
		this.shipProc = shipProc;
		this.orderamount = orderamount;
		this.dueDate = dueDate;
	}

	public OrderItemBean() {
	}

	public int getOrderno() {
		return orderno;
	}

	public void setOrderno(int orderno) {
		this.orderno = orderno;
	}

	public int getItemno() {
		return itemno;
	}

	public void setItemno(int itemno) {
		this.itemno = itemno;
	}

	public int getManuProc() {
		return manuProc;
	}

	public void setManuProc(int manuProc) {
		this.manuProc = manuProc;
	}

	public String getShipProc() {
		return shipProc;
	}

	public void setShipProc(String shipProc) {
		this.shipProc = shipProc;
	}

	public int getOrderamount() {
		return orderamount;
	}

	public void setOrderamount(int orderamount) {
		this.orderamount = orderamount;
	}

	public Timestamp getDueDate() {
		return dueDate;
	}

	public void setDueDate(Timestamp dueDate) {
		this.dueDate = dueDate;
	}

	public String getOrderOpt() {
		return orderOpt;
	}

	public void setOrderOpt(String orderOpt) {
		this.orderOpt = orderOpt;
	}

	public String getSeller() {
		return seller;
	}

	public void setSeller(String seller) {
		this.seller = seller;
	}

	public String getParcel() {
		return parcel;
	}

	public void setParcel(String parcel) {
		this.parcel = parcel;
	}

	public int getReviewNo() {
		return reviewNo;
	}

	public void setReviewNo(int reviewNo) {
		this.reviewNo = reviewNo;
	}

}
