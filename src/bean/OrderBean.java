package bean;

import java.sql.Timestamp;

public class OrderBean {

	private int orderno;
	private String orderer;
	private Timestamp orderdate;
	private String recipient;
	private int reczipcode;
	private String recaddr1;
	private String recaddr2;
	private String recphone;

	public OrderBean(int orderno, String orderer, Timestamp orderdate) {
		this.orderno = orderno;
		this.orderer = orderer;
		this.orderdate = orderdate;
	}

	public OrderBean() {
	}

	public String getRecipient() {
		return recipient;
	}

	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}

	public int getReczipcode() {
		return reczipcode;
	}

	public void setReczipcode(int reczipcode) {
		this.reczipcode = reczipcode;
	}

	public String getRecaddr1() {
		return recaddr1;
	}

	public void setRecaddr1(String recaddr1) {
		this.recaddr1 = recaddr1;
	}

	public String getRecaddr2() {
		return recaddr2;
	}

	public void setRecaddr2(String recaddr2) {
		this.recaddr2 = recaddr2;
	}

	public String getRecphone() {
		return recphone;
	}

	public void setRecphone(String recphone) {
		this.recphone = recphone;
	}

	public int getOrderno() {
		return orderno;
	}

	public void setOrderno(int orderno) {
		this.orderno = orderno;
	}

	public String getOrderer() {
		return orderer;
	}

	public void setOrderer(String orderer) {
		this.orderer = orderer;
	}

	public Timestamp getOrderdate() {
		return orderdate;
	}

	public void setOrderdate(Timestamp orderdate) {
		this.orderdate = orderdate;
	}

}
