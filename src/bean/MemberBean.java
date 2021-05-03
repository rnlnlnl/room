package bean;

import java.sql.Timestamp;

public class MemberBean {
	private String id;
	private String pw;
	private String name;
	private String nickname;
	private String email;
	private Timestamp joindate;
	private int zipcode;
	private String addr1;
	private String addr2;
	private String auth;
	private String style;
	private boolean idisable;

	public MemberBean(String id, String pw, String name, String nickname, String email, int zipcode, String addr1, String addr2, String auth, String style) {
		this.id = id;
		this.pw = pw;
		this.name = name;
		this.nickname = nickname;
		this.email = email;
		this.zipcode = zipcode;
		this.addr1 = addr1;
		this.addr2 = addr2;
		this.auth = auth;
		this.style = style;
	}

	public MemberBean(String id, String pw, String name, String nickname, String email, Timestamp joindate, int zipcode, String addr1, String addr2, String auth, String style) {
		this.id = id;
		this.pw = pw;
		this.name = name;
		this.nickname = nickname;
		this.email = email;
		this.joindate = joindate;
		this.zipcode = zipcode;
		this.addr1 = addr1;
		this.addr2 = addr2;
		this.auth = auth;
		this.style = style;
	}

	public MemberBean(String id, String nickname, String email, int zipcode, String addr1, String addr2, String style) {
		this.id = id;
		this.nickname = nickname;
		this.email = email;
		this.zipcode = zipcode;
		this.addr1 = addr1;
		this.addr2 = addr2;
		this.style = style;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Timestamp getJoindate() {
		return joindate;
	}

	public void setJoindate(Timestamp joindate) {
		this.joindate = joindate;
	}

	public int getZipcode() {
		return zipcode;
	}

	public void setZipcode(int zipcode) {
		this.zipcode = zipcode;
	}

	public String getAddr1() {
		return addr1;
	}

	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}

	public String getAddr2() {
		return addr2;
	}

	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}

	public String getAuth() {
		return auth;
	}

	public void setAuth(String auth) {
		this.auth = auth;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public boolean isIdisable() {
		return idisable;
	}

	public void setIdisable(boolean idisable) {
		this.idisable = idisable;
	}
}
