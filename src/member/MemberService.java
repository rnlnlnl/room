package member;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import bean.LetterBean;
import bean.MemberBean;

public class MemberService {

	MemberDAO mDAO;

	public MemberService() {
		// 객체 생성시 자동으로 dao 객체 생성
		mDAO = new MemberDAO();
	}

	public int login(String id, String pw) {
		int result = mDAO.login(id, pw);

		return result;
	}

	public String getAuth(String memberId) {
		String auth = mDAO.getAuth(memberId);

		return auth;
	}

	public ArrayList<LetterBean> listLetter(String id, String sr, int startRow, int pageSize) {
		// db에서 이메일 얻기
		ArrayList<LetterBean> list = mDAO.listLetter(id, sr, startRow, pageSize);
		return list;
	}

	public ArrayList<MemberBean> listMember() { // 전체 회원 목록
		ArrayList<MemberBean> listMember = mDAO.listMember();
		return listMember;
	}

	public int checkDupId(String id) {
		int result = mDAO.checkDupId(id);
		return result;
	}

	public boolean checkDupEmail(String email) {
		boolean result = mDAO.checkDupEmail(email);
		return result;
	}

	public void addMember(MemberBean memberBean) {
		mDAO.addMember(memberBean);
	}

	public String findId(String name, String email) {
		String id = mDAO.findId(name, email);
		return id;
	}

	public void modPw(String id, String pw) {
		mDAO.modPw(id, pw);
	}

	public MemberBean infoMember(String id) {
		MemberBean memberBean = mDAO.searchMember("id", id);

		return memberBean;
	}

	public boolean modMember(MemberBean memberBean) {
		return mDAO.modMember(memberBean);
	}

	public void delMember(String id) {
		System.out.println("dd");
		mDAO.delMember(id);
	}

	public void addLetter(LetterBean letterBean) {
		mDAO.addLetter(letterBean);
	}

	public List<MemberBean> listSeller() {
		List<MemberBean> memberList = mDAO.listMember();
		List<MemberBean> sellerList = new ArrayList<MemberBean>();

		for (int i = 0; i < memberList.size(); i++) {
			MemberBean member = memberList.get(i);

			if (member.getAuth().equals("s") || member.getAuth().equals("S")) {
				sellerList.add(member);
			}
		}

		return sellerList;
	}

	public int countLetter(String id, String sr) {
		int postCount = mDAO.countLetter(id, sr);
		return postCount;
	}

	public void delLetter(int[] letterNo, String rs) {
		mDAO.delLetter(letterNo, rs);
	}

	public LetterBean readLetter(int letterNo, String rs) {
		LetterBean letterBean = mDAO.readLetter(letterNo, rs);
		return letterBean;
	}

	/* ###################################DAO가지 않는 서비스 작업############################################## */

	public boolean emailCert(String email) {
		String certNum = createCertNum();

		boolean result = emailCertSend(email, certNum);

		return result;
	}

	public boolean emailCertSend(String email, String authNum) {
		boolean result = false;

		String sender = "test.skin.an@gmail.com";
		String subject = "____ROOMDY 가구 제작 홈쇼핑이니다.";
		String content = "안녕하세요 " + email + "님, <br>" + "귀하의 인증번호는    [<b>" + authNum + "</b>]   입니다.";

		try {
			Properties properties = System.getProperties();

			properties.put("mail.smtp.starttls.enable", "true");
			properties.put("mail.smtp.host", "smtp.gmail.com");
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.port", "587");

			Authenticator auth = new GoogleAuthentication();
			Session session = Session.getDefaultInstance(properties, auth);
			Message message = new MimeMessage(session);
			Address senderAd = new InternetAddress(sender);
			Address receiverAd = new InternetAddress(email);

			message.setHeader("content-type", "text/html;charset=UTF-8");
			message.setFrom(senderAd);
			message.addRecipient(RecipientType.TO, receiverAd);
			message.setSubject(subject);
			message.setContent(content, "text/html;charset=UTF-8");
			message.setSentDate(new Date());

			Transport.send(message);
			result = true;
		} catch (Exception e) {
			System.out.println("MemberService : emailCertSend(인증번호 전송 메서드)에서 에러" + e);
		}

		return result;
	}

	public boolean modRandPw(String id, String email) {// 랜덤으로 생성된 임시 비밀번호를 메일로 전송하는 메서드
		boolean result = false;

		String modPw = createRandomPw();

		// 임시 비밀번호를 db에도 수정시킨다.
		modPw(id, modPw);

		String sender = "test.skin.an@gmail.com";
		String subject = "____ROOMDY 가구 제작 홈쇼핑이니다.";
		String content = "안녕하세요 " + email + "님, <br>" + "귀하의 임시비밀번호는    [<b>" + modPw + "</b>]   입니다.";

		try {
			Properties properties = System.getProperties();
			properties.put("mail.smtp.starttls.enable", "true");
			properties.put("mail.smtp.host", "smtp.gmail.com");
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.port", "587");
			Authenticator auth = new GoogleAuthentication();
			Session session = Session.getDefaultInstance(properties, auth);
			Message message = new MimeMessage(session);
			Address senderAd = new InternetAddress(sender);
			Address receiverAd = new InternetAddress(email);
			message.setHeader("content-type", "text/html;charset=UTF-8");
			message.setFrom(senderAd);
			message.addRecipient(RecipientType.TO, receiverAd);
			message.setSubject(subject);
			message.setContent(content, "text/html;charset=UTF-8");
			message.setSentDate(new Date());
			Transport.send(message);
			result = true;
		} catch (Exception e) {
			System.out.println("MemberService : modRandPwSendEamil(임시 비밀번호 이메일 전송 메서드)에서 에러" + e);
		}

		return result;
	}

	// 회원가입 이메일 인증시 전송되는 랜덤한 숫자 6자리 생성 메서드
	public String createCertNum() {
		StringBuffer certNum = new StringBuffer();

		for (int i = 0; i < 6; ++i) {
			int randNum = (int) (Math.random() * 10.0D);
			certNum.append(randNum);
		}

		return certNum.toString();
	}// 이메일 인증 번호 6자리 메서드 끝

	public String createRandomPw() {// 랜덤한 비밀번호 8자리 생성 메서드
		String randomPw = UUID.randomUUID().toString().replaceAll("-", "");
		randomPw = randomPw.substring(0, 8);

		return randomPw;
	}

}

class GoogleAuthentication extends Authenticator {

	PasswordAuthentication passAuth = new PasswordAuthentication("test.skin.an@gmail.com", "!!11qqqq");

	public PasswordAuthentication getPasswordAuthentication() {
		return this.passAuth;
	}

}
