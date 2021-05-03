package bean;

import java.sql.Timestamp;

public class LetterBean {
	private int letterno;
	private int state;
	private String recipient;
	private String sender;
	private String title;
	private String content;
	private Timestamp senddate;
	private String file;
	private boolean isread;

	public LetterBean(String recipient, String sender, String title, String content, Timestamp senddate, String file, boolean isread) {
		this.recipient = recipient;
		this.sender = sender;
		this.title = title;
		this.content = content;
		this.senddate = senddate;
		this.file = file;
		this.isread = isread;
	}

	public LetterBean(String sender, String recipient, String title, String content) {
		this.sender = sender;
		this.recipient = recipient;
		this.title = title;
		this.content = content;
	}

	public LetterBean() {
	}

	public int getLetterno() {
		return letterno;
	}

	public void setLetterno(int letterno) {
		this.letterno = letterno;
	}

	public int getState() {
		return state;
	}

	public void setState(int state) {
		this.state = state;
	}

	public String getRecipient() {
		return recipient;
	}

	public void setRecipient(String recipient) {
		this.recipient = recipient;
	}

	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Timestamp getSenddate() {
		return senddate;
	}

	public void setSenddate(Timestamp senddate) {
		this.senddate = senddate;
	}

	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}

	public boolean getIsread() {
		return isread;
	}

	public void setIsread(boolean isread) {
		this.isread = isread;
	}
}
