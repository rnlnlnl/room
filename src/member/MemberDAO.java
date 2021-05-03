package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import bean.LetterBean;
import bean.MemberBean;

public class MemberDAO {
	// 커넥션,프리페어드스테이트먼트,리설트셋 미리 선언해뒀습니다
	// 아래의 이름으로 사용해 주세요

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

	// 자원 반납메소드
	private void closeAll(Connection conn, PreparedStatement pst, ResultSet res) {
		try {
			if (conn != null)
				conn.close();
			if (pst != null)
				pst.close();
			if (res != null)
				res.close();
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("MemberDAO : closeAll(자원 반납 작업)에서 에러" + e);
		}
	}// closeAll()메서드 끝

	// login 아이디 비밀번호 비교(회원 탈퇴시 확인하는 작업도 추가)
	// 0122 지연 :비밀번호 틀렸을시는 알려주지 않고 탈퇴한 회원이 로그인을 시도할 떄 탈퇴한 회원이라고 알리고 로그인을 못하게 한다/
	public int login(String id, String pw) {

		int result = -1;
		/*
		 * 1 : 로그인 성공 0 : 탈퇴한 회원이다.(로그인 실패) -1 : 로그인 실패(아이디 틀리거나 비번 틀림)
		 */

		try {
			conn = getConnection();

			sql = "SELECT * FROM dymember WHERE id = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, id);

			res = pst.executeQuery();

			if (res.next()) {
				if ((res.getInt("idisable") == 0)) { //탈퇴한 회원일 경우
					result++;
				} else if (pw.equals(res.getString("pw"))) {
					result = 1;
				}
			}
		} catch (Exception e) {
			System.out.println("MemberDAO : login(로그인 작업)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}
		return result;
	} // login 메소드 종료

	// 권한 얻기 작업
	public String getAuth(String id) {
		String auth = null;

		try {
			conn = getConnection();

			sql = "SELECT auth FROM dymember WHERE id = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, id);
			res = pst.executeQuery();

			if (res.next()) {
				auth = res.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("MemberDAO : getAuth(권한 얻기 작업)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}
		return auth;
	} // getAuth 메소드 종료

	// 회원삭제
	public void delMember(String id) {
		try {
			conn = getConnection();

			sql = "UPDATE dymember SET idisable = false, pw = '', name = '', nickname = '', email = '', zipcode = 0, addr1 = '',addr2 = '', style = '' WHERE id = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, id);

			pst.executeUpdate();
		} catch (Exception e) {
			System.out.println("MemberDAO : delMember(회원삭제 작업)에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}
	}// delMember메소드 종료

	// 회원가입시 중복 아이디가 있는지 확인하는 메서드
	/*
	 * 0122 지연 : 회원탈퇴시 사용하고 있던 아이디로 다시 회원가입 하지 못하게 하기 위해서 회원탈퇴한 아이디는 사용하지 못한다고 알려주기 위해
	 * 
	 * 1 : 회원가입 가능하다 0 : 중복된 아이디다 -1 : 회원탈퇴한 아이디다 사용불가여
	 */

	public int checkDupId(String id) {
		int check = 1;

		try {
			conn = getConnection();

			sql = "SELECT * FROM dymember WHERE id=?";

			pst = conn.prepareStatement(sql);
			pst.setString(1, id);

			res = pst.executeQuery();

			if (res.next()) {
				check--;
			}
			if (res.getInt("idisable") == 0) {
				check--;
			}
		} catch (Exception e) {
			System.out.println("MemberDAO : checkDupId(중복 아이디 검사 작업)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}

		return check;
	}// checkDupId() 끝

	// 회원가입시 중복 이메일 있는지 확인하는 메서드
	public boolean checkDupEmail(String email) {
		boolean check = false;

		try {
			conn = getConnection();

			sql = "SELECT * FROM dymember WHERE email=?";

			pst = conn.prepareStatement(sql);
			pst.setString(1, email);

			res = pst.executeQuery();

			if (res.next())
				check = true;
		} catch (Exception e) {
			System.out.println("MemberDAO : checkDupEmail(중복 이메일 검사 작업)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}

		return check;
	}// checkDupEmail() 끝

	//쪽지 리스트
	public ArrayList<LetterBean> listLetter(String id, String sr, int startRow, int pageSize) {
		ArrayList<LetterBean> listLetter = new ArrayList<LetterBean>();

		try {

			conn = getConnection();

			if (sr.equals("receiveLetter")) { //받은 쪽지함 호출
				sql = "select * from dyletter where recipient = ? and state != 1 order by isread, senddate desc limit ?, ?";
			} else { //보낸 쪽지함 호출
				sql = "select * from dyletter where sender = ? and state != 2 order by senddate desc limit ?, ?";
			}

			pst = conn.prepareStatement(sql);

			pst.setString(1, id);
			pst.setInt(2, startRow);
			pst.setInt(3, pageSize);

			res = pst.executeQuery();

			while (res.next()) {
				LetterBean letter = new LetterBean();

				letter.setLetterno(res.getInt("no"));
				letter.setSender(res.getString("sender"));
				letter.setRecipient(res.getString("recipient"));
				letter.setTitle(res.getString("title"));
				letter.setIsread(res.getBoolean("isread"));
				letter.setState(res.getInt("state"));

				Timestamp sqlTime = res.getTimestamp("senddate");

				Calendar cal = Calendar.getInstance();

				cal.setTimeInMillis(sqlTime.getTime());
				cal.add(Calendar.HOUR, -9);

				letter.setSenddate(new Timestamp(cal.getTime().getTime()));

				listLetter.add(letter);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("MemberDAO : listLetter(쪽지 목록 얻기)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}
		return listLetter;
	}

	// 회원가입 성공시 회원 DB에 추가 하는 메서드
	public void addMember(MemberBean memberBean) {
		try {

			conn = getConnection();

			String sql = "insert into dymember(id, pw, name, nickname, email, zipcode, addr1, addr2, auth, style) values(?,?,?,?,?,?,?,?,?,?)";

			pst = conn.prepareStatement(sql);

			pst.setString(1, memberBean.getId());
			pst.setString(2, memberBean.getPw());
			pst.setString(3, memberBean.getName());
			pst.setString(4, memberBean.getNickname());
			pst.setString(5, memberBean.getEmail());
			pst.setInt(6, memberBean.getZipcode());
			pst.setString(7, memberBean.getAddr1());
			pst.setString(8, memberBean.getAddr2());
			pst.setString(9, memberBean.getAuth());
			pst.setString(10, memberBean.getStyle());

			pst.executeUpdate();

		} catch (Exception e) {

			System.out.println("MemberDAO : addMember(회원가입 성공시 회원추가 작업)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

	}// addMember() 메서드 끝

	// 관리자 모드에서 회원 목록 얻는 메서드
	public ArrayList<MemberBean> listMember() {
		ArrayList<MemberBean> listMember = new ArrayList<MemberBean>();

		try {

			conn = getConnection();

			sql = "select * from dymember where idisable = 1 order by joindate desc ";

			pst = conn.prepareStatement(sql);

			res = pst.executeQuery();

			while (res.next()) {
				String id = res.getString("id");
				String pw = res.getString("pw");
				String name = res.getString("name");
				String nickname = res.getString("nickname");
				String email = res.getString("email");
				Timestamp joindate = res.getTimestamp("joindate");
				int zipcode = res.getInt("zipcode");
				String addr1 = res.getString("addr1");
				String addr2 = res.getString("addr2");
				String auth = res.getString("auth");
				String style = res.getString("style");

				MemberBean member = new MemberBean(id, pw, name, nickname, email, joindate, zipcode, addr1, addr2, auth, style);

				listMember.add(member);
			}

		} catch (Exception e) {
			System.out.println("MemberDAO : listMember(회원 목록 얻기)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}
		return listMember;
	} // listMember() 끝

	// 회원 검색하는 메서드
	public MemberBean searchMember(String searKey, String searVal) {
		MemberBean member = null;

		try {
			conn = getConnection();

			sql = "SELECT * FROM dymember WHERE " + searKey + " = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, searVal);

			res = pst.executeQuery();

			if (res.next()) {
				String id = res.getString("id");
				String pw = res.getString("pw");
				String name = res.getString("name");
				String nickname = res.getString("nickname");
				String email = res.getString("email");
				Timestamp joindate = res.getTimestamp("joindate");
				int zipcode = res.getInt("zipcode");
				String addr1 = res.getString("addr1");
				String addr2 = res.getString("addr2");
				String auth = res.getString("auth");
				String style = res.getString("style");

				member = new MemberBean(id, pw, name, nickname, email, joindate, zipcode, addr1, addr2, auth, style);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("MemberDAO : searchMember(회원 검색)에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}

		return member;
	} // findMember() 끝

	// 회원 정보수정하는 메서드(비밀번호 제외)
	public boolean modMember(MemberBean member) {

		boolean result = false;

		try {
			conn = getConnection();

			String sql = "UPDATE dymember SET nickname = ?, email = ?, zipcode = ?, addr1 = ?, addr2 = ?, style = ?  WHERE id = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, member.getNickname());
			pst.setString(2, member.getEmail());
			pst.setInt(3, member.getZipcode());
			pst.setString(4, member.getAddr1());
			pst.setString(5, member.getAddr2());
			pst.setString(6, member.getStyle());
			pst.setString(7, member.getId());

			pst.executeUpdate();
			result = true;
		} catch (Exception e) {

			System.out.println("MemberDAO : modMember(회원정보 수정 작업)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return result;
	} // modMember() 끝

	// 가입시 입력한 이름과 이메일을 이용해 아이디 찾는 메서드
	public String findId(String name, String email) {
		String id = null;

		try {
			conn = getConnection();

			String sql = "SELECT id FROM dymember WHERE email=? AND name = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, email);
			pst.setString(2, name);

			res = pst.executeQuery();

			while (res.next()) {
				id = res.getString(1);
			}
		} catch (Exception e) {
			System.out.println("MemberDAO : findId(아이디 찾기)에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}
		return id;
	}// findId()메서드 끝

	// 비밀번호 변경 메서드(비밀번호 찾기시 임시 비밀번호 생성 작업)
	public void modPw(String id, String pw) {
		try {
			conn = getConnection();

			String sql = "UPDATE dymember SET pw = ? WHERE id = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, pw);
			pst.setString(2, id);

			pst.executeUpdate();

		} catch (Exception e) {

			System.out.println("MemberDAO : modPw(비밀번호 변경)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}
	}// modPw() 끝

	public void addLetter(LetterBean letterBean) {
		try {
			conn = getConnection();

			String sql = "INSERT INTO dyletter (sender, recipient, title, content) VALUES (?,?,?,?)";

			pst = conn.prepareStatement(sql);

			pst.setString(1, letterBean.getSender());
			pst.setString(2, letterBean.getRecipient());
			pst.setString(3, letterBean.getTitle());
			pst.setString(4, letterBean.getContent());

			pst.executeUpdate();
		} catch (Exception e) {

			System.out.println("MemberDAO : addLetter(쪽지 보내기)에서 에러" + e);
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}
	}

	public int countLetter(String id, String sr) {
		int postCount = 0;

		try {
			conn = getConnection();

			if (sr.equals("receiveLetter")) { //받은 쪽지함 호출
				sql = "select count(*) from dyletter where recipient = ? and state = 0";
			} else { //보낸 쪽지함 호출
				sql = "select count(*) from dyletter where sender = ? and state = 0";
			}

			pst = conn.prepareStatement(sql);

			pst.setString(1, id);

			res = pst.executeQuery();

			if (res.next()) {
				postCount = res.getInt(1);
			}
		} catch (Exception e) {
			System.out.println("MemberDAO : countLetter(쪽지 개수)에서 에러" + e);
			e.printStackTrace();
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return postCount;
	}

	public void delLetter(int[] letterNo, String rs) {
		try {
			conn = getConnection();

			for (int i = 0; i < letterNo.length; i++) {
				if (rs.equals("receiveLetter")) {
					sql = "update dyletter set state = state+1 where no = ?";
				} else {
					sql = "update dyletter set state = state+2 where no = ?";
				}

				pst = conn.prepareStatement(sql);

				pst.setInt(1, letterNo[i]);

				pst.execute();
			}

			sql = "DELETE from dyletter where state = 3";

			pst = conn.prepareStatement(sql);

			pst.execute();

		} catch (Exception e) {

			System.out.println("MemberDAO : addLetter(쪽지 보내기)에서 에러" + e);
			e.printStackTrace();
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}
	}

	public LetterBean readLetter(int letterNo, String rs) {
		LetterBean letterBean = new LetterBean();

		try {
			conn = getConnection();

			sql = "select * from dyletter where no = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, letterNo);

			res = pst.executeQuery();

			if (res.next()) {
				letterBean.setLetterno(letterNo);
				letterBean.setTitle(res.getString("title"));
				letterBean.setSender(res.getString("sender"));
				letterBean.setRecipient(res.getString("recipient"));
				letterBean.setContent(res.getString("content"));

				Timestamp sqlTime = res.getTimestamp("senddate");

				Calendar cal = Calendar.getInstance();

				cal.setTimeInMillis(sqlTime.getTime());
				cal.add(Calendar.HOUR, -9);

				letterBean.setSenddate(new Timestamp(cal.getTime().getTime()));
			}

			if (rs.equals("r")) {
				sql = "update dyletter set isread = ? where no = ?";

				pst = conn.prepareStatement(sql);

				pst.setBoolean(1, true);
				pst.setInt(2, letterNo);

				pst.execute();

			}
		} catch (Exception e) {
			System.out.println("MemberDAO : readLetter(쪽지 읽기)에서 에러" + e);
			e.printStackTrace();
		} finally {
			// 자원해제
			closeAll(conn, pst, null);
		}

		return letterBean;
	}
}
