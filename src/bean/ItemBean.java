package bean;

public class ItemBean {
	private int itemno, cost, preferage, amount, heart, dueDate;
	private String itemname, itemCate, itemColor, style, seller, itemImg;
	boolean isUse;

	public ItemBean() {
	}

	public ItemBean(boolean isUse, int itemno, int cost, int amount, String itemname, String itemCate, String itemImg, int heart) {
		this.isUse = isUse;
		this.itemno = itemno;
		this.cost = cost;
		this.amount = amount;
		this.itemname = itemname;
		this.itemCate = itemCate;
		this.itemImg = itemImg;
		this.heart = heart;
	}

	public ItemBean(int itemno, int cost, String itemname, String itemCate, String itemImg, int heart) {
		this.itemno = itemno;
		this.cost = cost;
		this.heart = heart;
		this.itemname = itemname;
		this.itemCate = itemCate;
		this.itemImg = itemImg;
	}

	public ItemBean(int itemno, int cost, int preferage, int amount, int heart, int dueDate, String itemname, String itemCate, String itemColor, String style, String seller, String itemImg, boolean isUse) {
		this.itemno = itemno;
		this.cost = cost;
		this.preferage = preferage;
		this.amount = amount;
		this.heart = heart;
		this.dueDate = dueDate;
		this.itemname = itemname;
		this.itemCate = itemCate;
		this.itemColor = itemColor;
		this.style = style;
		this.seller = seller;
		this.itemImg = itemImg;
		this.isUse = isUse;
	}

	public ItemBean(int itemno, int amount) {
		
		this.itemno = itemno;
		this.amount = amount;
	}

	public int getItemno() {
		return itemno;
	}

	public ItemBean(int itemNo, int cost, String itemname, String itemCate, String itemColor, int preferage, String style, int amount, String itemImg) {
		this.itemno = itemno;
		this.cost = cost;
		this.itemname = itemname;
		this.itemCate = itemCate;
		this.itemColor = itemColor;
		this.preferage = preferage;
		this.style = style;
		this.amount = amount;
		this.itemImg = itemImg;
	}

	public ItemBean(String seller, int cost, String itemname, String itemCate, String itemColor, int preferage, String style, int amount, String itemImg) {
		this.seller = seller;
		this.cost = cost;
		this.itemname = itemname;
		this.itemCate = itemCate;
		this.itemColor = itemColor;
		this.preferage = preferage;
		this.style = style;
		this.amount = amount;
		this.itemImg = itemImg;
	}

	public void setItemno(int itemno) {
		this.itemno = itemno;
	}

	public int getCost() {
		return cost;
	}

	public void setCost(int cost) {
		this.cost = cost;
	}

	public int getPreferage() {
		return preferage;
	}

	public void setPreferage(int preferage) {
		this.preferage = preferage;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public int getHeart() {
		return heart;
	}

	public void setHeart(int heart) {
		this.heart = heart;
	}

	public int getDueDate() {
		return dueDate;
	}

	public void setDueDate(int dueDate) {
		this.dueDate = dueDate;
	}

	public String getItemname() {
		return itemname;
	}

	public void setItemname(String itemname) {
		this.itemname = itemname;
	}

	public String getItemCate() {
		return itemCate;
	}

	public void setItemCate(String itemCate) {
		this.itemCate = itemCate;
	}

	public String getItemColor() {
		return itemColor;
	}

	public void setItemColor(String itemColor) {
		this.itemColor = itemColor;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public String getSeller() {
		return seller;
	}

	public void setSeller(String seller) {
		this.seller = seller;
	}

	public String getItemImg() {
		return itemImg;
	}

	public void setItemImg(String itemImg) {
		this.itemImg = itemImg;
	}

	public boolean getIsUse() {
		return isUse;
	}

	public void setIsUse(boolean isUse) {
		this.isUse = isUse;
	}

}
