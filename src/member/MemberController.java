package member;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.ItemBean;
import bean.LetterBean;
import bean.MemberBean;
import board.BoardService;
import item.ItemService;

//컨텍스트 패스가 /member 로 시작하는 모든 요청은 이 서블릿에서 처리합니다
@WebServlet("/member/*")
public class MemberController extends HttpServlet {
	MemberDAO mDAO;

	// init()메소드에서 MemberDAO객체를 초기화함.
	@Override
	public void init() throws ServletException {
		mDAO = new MemberDAO();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doIt(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doIt(request, response);
	}

	public void doIt(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		// 뷰페이지(요청한 작업을 완료한 후 보여줄 페이지) 주소를 저장할 변수
		String nextPage = null;
		boolean isRedirect = false;

		// 이 서블릿을 요청한 페이지 주소얻기
		String path = request.getPathInfo();
		System.out.println("member 요청 주소 path :  " + path);

		// 실제로 요청을 처리할 서비스 객체, 이안에 모든 처리 메소드 들어있음
		MemberService service = new MemberService();
		HttpSession session = request.getSession();

		// ajax / javascirpt 로 출력할 때 사용할 printWrite 객체 생성
		PrintWriter out = response.getWriter();

		ItemService itemService = new ItemService();
		BoardService boardService = new BoardService();

		// path if문 순서 : 페이지 이동 작업 - service 전달 - ajax 작업 순으로 정렬

		/* ##########################################페이지 이동########################################## */
		if (path.equals("/main.do")) { // main 페이지 요청
			String auth = (String) session.getAttribute("auth");
			String id = (String) session.getAttribute("memberId");

			if (auth == null || auth.equals("b") || auth.equals("B")) {
				List<ItemBean> styleItemList;

				if (itemService.styleItemList(id, auth).size() > 4) {
					styleItemList = itemService.styleItemList(id, auth).subList(0, 4);
				}
				else {
					styleItemList = itemService.styleItemList(id, auth);
				}

				List reviewList = boardService.listReview(-1, 0, 3);//글 번호 칸에 -1을 넣어서 dao에서 구분

				request.setAttribute("styleItemList", styleItemList);
				request.setAttribute("reviewList", reviewList);
			}
			else if (auth.equals("S") || auth.equals("s")) {
				List listSoldItem = itemService.listSoldItem(id);

				if (listSoldItem.size() > 3)
					listSoldItem = listSoldItem.subList(0, 3);

				request.setAttribute("listSoldItem", listSoldItem);
			}

			nextPage = "../pages/defaultMain.jsp";
		}
		else if (path.equals("/joinPage.do")) {// 약관 페이지로 이동
			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "member/joinPage.jsp");
		}
		else if (path.equals("/joinForm.do")) {// 회원가입 Form 페이지로 이동
			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "member/joinForm.jsp");
		}
		else if (path.equals("/findInfo.do")) {// 회원가입 Form 페이지로 이동
			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "member/findInfo.jsp");
		}
		/* ##########################################service 작업########################################## */
		else if (path.equals("/letterPage.do")) {// 쪽지 페이지
			String letterCenter = request.getParameter("letterCenter");
			String id = (String) session.getAttribute("memberId");

			if (letterCenter == null) {
				letterCenter = "receiveLetter";
			}

			/* ==========페이징 작업========= */

			int pageSize = 10; //한 페이지에 보여줄 글 개수

			int page;

			if (request.getParameter("page") == null) {
				page = 1;
			}
			else {
				page = Integer.parseInt(request.getParameter("page"));
			}

			int startRow = (page - 1) * pageSize;

			int postCount = service.countLetter(id, letterCenter);
			int pageCount = postCount / pageSize + (postCount % pageSize == 0 ? 0 : 1);

			int pageBlock = 5; //한 페이지에 보여질 페이징 갯수

			int startPage = ((page / pageBlock) - (page % pageBlock == 0 ? 1 : 0)) * pageBlock + 1;
			int endPage = startPage + pageBlock - 1;

			if (endPage > pageCount)
				endPage = pageCount;

			request.setAttribute("pageCount", pageCount);
			request.setAttribute("startPage", startPage);
			request.setAttribute("endPage", endPage);
			request.setAttribute("pageBlock", pageBlock);

			/* ==========페이징 작업 끝========= */

			if (id == null)
				id = "buy";

			if (letterCenter.equals("writeLetter")) {
				request.setAttribute("sellerList", service.listSeller());
			}
			else if (letterCenter.equals("receiveLetter")) {//받은 쪽지함
				request.setAttribute("letterList", service.listLetter(id, letterCenter, startRow, pageSize));
			}
			else if (letterCenter.equals("sendLetter")) {//보낸 쪽지함
				request.setAttribute("letterList", service.listLetter(id, letterCenter, startRow, pageSize));
			}

			request.setAttribute("letterCenter", letterCenter);
			nextPage = "../pages/member/letter.jsp";
		}
		else if (path.equals("/addMember.do")) {// 회원가입 Form 페이지로 이동

			String id = request.getParameter("id");
			String pw = request.getParameter("pw");
			String name = request.getParameter("name");
			String nickname = request.getParameter("nickname");
			String email = request.getParameter("email");
			int zipcode = Integer.parseInt(request.getParameter("zipcode"));
			String addr1 = request.getParameter("addr1");
			String addr2 = request.getParameter("addr2");
			String auth = request.getParameter("auth");
			String style = request.getParameter("style");

			MemberBean memberBean = new MemberBean(id, pw, name, nickname, email, zipcode, addr1, addr2, auth, style);

			service.addMember(memberBean);

			nextPage = "main.do";
			isRedirect = true;
		}
		else if (path.equals("/myPage.do")) {// session에 등록된 회원 한 명의 정보를 받아와 myPage 페이지에서 출력
			String id = (String) session.getAttribute("memberId");

			MemberBean memberBean = service.infoMember(id);

			request.setAttribute("memberBean", memberBean);
			request.setAttribute("center", "member/myPage.jsp");

			nextPage = "../pages/defaultMain.jsp";
		}
		else if (path.equals("/listMember.do")) {
			List<MemberBean> listMember = service.listMember();

			request.setAttribute("listMember", listMember);
			request.setAttribute("center", "member/listMember.jsp");
			nextPage = "main.do";
		}
		else if (path.equals("/delMember.do")) {// 수정한 회원 정보 업데이트
			String id = (String) session.getAttribute("memberId");

			service.delMember(id);

			session.removeAttribute("memberId");
			session.removeAttribute("auth");

			nextPage = "main.do";
			isRedirect = true;
		}
		else if (path.equals("/addLetter.do")) {// 쪽지 보내기
			String sender = (String) session.getAttribute("memberId");
			String recipient = request.getParameter("recipient");
			String title = request.getParameter("title");
			String content = request.getParameter("content");

			LetterBean letterBean = new LetterBean(sender, recipient, title, content);

			service.addLetter(letterBean);

			nextPage = "letterPage.do";
		}
		else if (path.equals("/readLetter.do")) {// 쪽지 읽기
			int letterNo = Integer.parseInt(request.getParameter("letterNo"));
			String rs = request.getParameter("rs");

			LetterBean letterBean = service.readLetter(letterNo, rs);

			request.setAttribute("letterBean", letterBean);

			nextPage = "../pages/member/letter.jsp?letterCenter=readLetter";
		}
		/* ##########################################ajax 작업########################################## */
		else if (path.equals("/login.do")) { // 로그인 ajax 작업
			String memberId = request.getParameter("id");
			String memberPw = request.getParameter("pw");

			int result = service.login(memberId, memberPw);

			String auth = service.getAuth(memberId).toUpperCase();

			if (result == 1) {
				session.setAttribute("memberId", memberId);
				session.setAttribute("auth", auth);
			}

			out.print(result);

			return;
		}
		else if (path.equals("/checkDupId.do")) { // 아이디 중복 체크
			String id = request.getParameter("id");

			int result = service.checkDupId(id);

			out.print(result);
			return;
		}
		else if (path.equals("/checkDupEmail.do")) { // 이메일 중복 체크
			String email = request.getParameter("email");

			boolean result = !service.checkDupEmail(email);

			out.print(result);
			return;
		}
		else if (path.equals("/findId.do")) { // 이름과 이메일을 통해 아이디 찾기
			String name = request.getParameter("name");
			String email = request.getParameter("email");

			String id = service.findId(name, email);

			out.print(id);
			return;
		}
		else if (path.equals("/modRandPw.do")) { // 비밀번호 찾기시 랜덤한 비밀번호로 DB변경함
			String id = request.getParameter("id");
			String email = request.getParameter("email");

			boolean result = service.modRandPw(id, email);

			out.print(result);
			return;
		}
		else if (path.equals("/modPw.do")) {// 회원의 정보 받아서 회원수정 Form 페이지로 이동
			String id = (String) session.getAttribute("memberId");
			String chagePw = request.getParameter("pw");

			service.modPw(id, chagePw);

			out.print("success");
			return;
		}
		else if (path.equals("/modMember.do")) {// 수정한 회원 정보 업데이트
			String id = request.getParameter("id");
			String nickname = request.getParameter("nickname");
			String email = request.getParameter("email");
			int zipcode = Integer.parseInt(request.getParameter("zipcode"));
			String addr1 = request.getParameter("addr1");
			String addr2 = request.getParameter("addr2");
			String style = request.getParameter("style");

			MemberBean memberBean = new MemberBean(id, nickname, email, zipcode, addr1, addr2, style);

			boolean result = service.modMember(memberBean);

			out.print(result);

			return;
		}
		else if (path.equals("/delLetter.do")) {// 쪽지 삭제
			int[] letterNo = Arrays.stream(request.getParameterValues("letterNo")).mapToInt(Integer::parseInt).toArray();
			String letterCenter = request.getParameter("letterCenter");
			String rs = request.getParameter("rs");

			if (rs != null) {
				if (rs.equals("r")) {
					letterCenter = "receiveLetter";
				}
				else {
					letterCenter = "sendLetter";
				}
			}
			System.out.println(letterCenter);

			service.delLetter(letterNo, letterCenter);

			return;
		}
		/* ##########################################기타########################################## */
		else if (path.equals("/logout.do")) { // 로그아웃 작업
			session.removeAttribute("memberId");
			session.removeAttribute("auth");

			nextPage = "main.do";
			isRedirect = true;
		}
		else if (path.equals("/emailCert.do")) {// 회원가입시 인증메일 전송
			String email = request.getParameter("email");
			String certNum = service.createCertNum();
			boolean result = service.emailCertSend(email, certNum);

			request.setAttribute("result", result);
			request.setAttribute("certNum", certNum);

			nextPage = "../pages/member/email_auth.jsp";
		}
		else if (path.equals("/error404")) {
			request.setAttribute("center", "../css/images/main/error404.png");

			nextPage = "../pages/defaultMain.jsp";
		}

		System.out.println("nextPgae : " + nextPage);

		if (nextPage != null) {
			if (isRedirect) {
				System.out.println("리다이렉트 방식");
				response.sendRedirect(nextPage);
			}
			else {
				System.out.println("디스패치 방식");
				RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
				// 실제 포워딩
				dispatcher.forward(request, response);
			}
		}
		// 그런 다음 디스패치 방식으로 View페이지로 포워딩
	}
}
