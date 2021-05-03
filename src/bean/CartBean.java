package bean;

public class CartBean {

	private String id;
	private int itemno;
	private int cartamount;
	private String cartopt;

	public String getCartopt() {
		return cartopt;
	}

	public void setCartopt(String cartopt) {
		this.cartopt = cartopt;
	}

	public CartBean(String id, int itemno, int cartamount) {
		this.id = id;
		this.itemno = itemno;
		this.cartamount = cartamount;
	}
	
	public CartBean(int cartamount) {
		this.cartamount = cartamount;
	}

	public CartBean() {
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getItemno() {
		return itemno;
	}

	public void setItemno(int itemno) {
		this.itemno = itemno;
	}

	public int getCartamount() {
		return cartamount;
	}

	public void setCartamount(int cartamount) {
		this.cartamount = cartamount;
	}

}
