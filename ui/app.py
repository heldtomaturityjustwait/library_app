"""
ui/app.py  –  Library Management System — tkinter GUI
NEU DATCOM Lab Project 01
"""

import tkinter as tk
from tkinter import ttk, messagebox, simpledialog

from services.services import BookService, ReaderService, LoanService

# ── Palette ────────────────────────────────────────────────────────────────
BG        = "#1a1f2e"
SIDEBAR   = "#141824"
CARD      = "#242938"
ACCENT    = "#4f8ef7"
ACCENT2   = "#38c98a"
DANGER    = "#e05c5c"
WARN      = "#f0a84e"
TXT       = "#e8ecf4"
TXT_DIM   = "#8a92a6"
BORDER    = "#2e3548"
FONT      = "Segoe UI"


# ── Helpers ────────────────────────────────────────────────────────────────

def styled_btn(parent, text, cmd, color=ACCENT, fg=TXT, width=None):
    kw = dict(text=text, command=cmd, bg=color, fg=fg, relief="flat",
              font=(FONT, 10, "bold"), padx=12, pady=6, cursor="hand2",
              activebackground=color, activeforeground=fg, bd=0)
    if width:
        kw["width"] = width
    b = tk.Button(parent, **kw)
    b.bind("<Enter>", lambda e: b.config(bg=_lighten(color)))
    b.bind("<Leave>", lambda e: b.config(bg=color))
    return b


def _lighten(hex_color):
    r, g, b = int(hex_color[1:3],16), int(hex_color[3:5],16), int(hex_color[5:7],16)
    return "#{:02x}{:02x}{:02x}".format(min(r+25,255), min(g+25,255), min(b+25,255))


def make_table(parent, columns, col_widths=None, height=14):
    style = ttk.Style()
    style.theme_use("clam")
    style.configure("Lib.Treeview",
                    background=CARD, foreground=TXT,
                    fieldbackground=CARD, rowheight=28,
                    font=(FONT, 10), borderwidth=0)
    style.configure("Lib.Treeview.Heading",
                    background=SIDEBAR, foreground=ACCENT,
                    font=(FONT, 10, "bold"), relief="flat")
    style.map("Lib.Treeview", background=[("selected", ACCENT)],
              foreground=[("selected", "#ffffff")])

    frame = tk.Frame(parent, bg=CARD)
    sb = ttk.Scrollbar(frame, orient="vertical")
    tree = ttk.Treeview(frame, columns=columns, show="headings",
                        style="Lib.Treeview", yscrollcommand=sb.set, height=height)
    sb.config(command=tree.yview)

    for i, col in enumerate(columns):
        w = col_widths[i] if col_widths else 140
        tree.heading(col, text=col)
        tree.column(col, width=w, anchor="w")

    tree.grid(row=0, column=0, sticky="nsew")
    sb.grid(row=0, column=1, sticky="ns")
    frame.grid_rowconfigure(0, weight=1)
    frame.grid_columnconfigure(0, weight=1)
    return frame, tree


def lbl(parent, text, size=11, bold=False, color=TXT, **kw):
    return tk.Label(parent, text=text, bg=kw.pop("bg", parent["bg"]),
                    fg=color, font=(FONT, size, "bold" if bold else "normal"), **kw)


def entry_row(parent, label, row, default="", width=30):
    lbl(parent, label, size=10, color=TXT_DIM).grid(row=row, column=0, sticky="w", padx=(0,10), pady=4)
    var = tk.StringVar(value=default)
    e = tk.Entry(parent, textvariable=var, width=width,
                 bg=BG, fg=TXT, insertbackground=TXT,
                 relief="flat", font=(FONT, 10), bd=4)
    e.grid(row=row, column=1, sticky="ew", pady=4)
    return var


# ══════════════════════════════════════════════════════════════════════════════
class LibraryApp(tk.Tk):

    def __init__(self):
        super().__init__()
        self.title("Library Management System — NEU")
        self.geometry("1200x720")
        self.configure(bg=BG)
        self.resizable(True, True)

        self.book_svc   = BookService()
        self.reader_svc = ReaderService()
        self.loan_svc   = LoanService()

        self._build_ui()
        self.show_page("dashboard")

    # ── Layout ────────────────────────────────────────────────────────────

    def _build_ui(self):
        # Sidebar
        self.sidebar = tk.Frame(self, bg=SIDEBAR, width=200)
        self.sidebar.pack(side="left", fill="y")
        self.sidebar.pack_propagate(False)

        lbl(self.sidebar, "📚  LibSystem", size=14, bold=True, bg=SIDEBAR,
            color=ACCENT).pack(pady=(28, 4), padx=16, anchor="w")
        lbl(self.sidebar, "NEU DATCOM Lab", size=9, color=TXT_DIM,
            bg=SIDEBAR).pack(padx=16, anchor="w")

        tk.Frame(self.sidebar, bg=BORDER, height=1).pack(fill="x", pady=16, padx=12)

        self.nav_btns = {}
        nav_items = [
            ("dashboard", "🏠  Dashboard"),
            ("books",     "📖  Books"),
            ("readers",   "👤  Readers"),
            ("borrow",    "➕  Borrow Book"),
            ("return",    "↩  Return Book"),
            ("loans",     "📋  Active Loans"),
            ("overdue",   "⚠️   Overdue"),
            ("history",   "🕐  History"),
        ]
        for key, label in nav_items:
            b = tk.Button(self.sidebar, text=label,
                          command=lambda k=key: self.show_page(k),
                          bg=SIDEBAR, fg=TXT, relief="flat",
                          font=(FONT, 10), anchor="w", padx=20, pady=10,
                          cursor="hand2", activebackground=CARD,
                          activeforeground=ACCENT, bd=0)
            b.pack(fill="x")
            self.nav_btns[key] = b

        # Main content area
        self.content = tk.Frame(self, bg=BG)
        self.content.pack(side="left", fill="both", expand=True)

        self.pages = {}
        for key, _ in nav_items:
            frame = tk.Frame(self.content, bg=BG)
            frame.place(relx=0, rely=0, relwidth=1, relheight=1)
            self.pages[key] = frame

        self._build_dashboard(self.pages["dashboard"])
        self._build_books(self.pages["books"])
        self._build_readers(self.pages["readers"])
        self._build_borrow(self.pages["borrow"])
        self._build_return(self.pages["return"])
        self._build_loans(self.pages["loans"])
        self._build_overdue(self.pages["overdue"])
        self._build_history(self.pages["history"])

    def show_page(self, key):
        self.pages[key].lift()
        for k, b in self.nav_btns.items():
            b.config(bg=CARD if k == key else SIDEBAR,
                     fg=ACCENT if k == key else TXT)
        # Refresh data when switching to data pages
        refresh = {
            "dashboard": self._refresh_dashboard,
            "books":     self._refresh_books,
            "readers":   self._refresh_readers,
            "loans":     self._refresh_loans,
            "overdue":   self._refresh_overdue,
            "history":   self._refresh_history,
        }
        if key in refresh:
            refresh[key]()

    # ── Dashboard ─────────────────────────────────────────────────────────

    def _build_dashboard(self, page):
        lbl(page, "Dashboard", size=18, bold=True).pack(anchor="w", padx=32, pady=(28,4))
        lbl(page, "Library overview at a glance", color=TXT_DIM).pack(anchor="w", padx=32)

        self.stat_frame = tk.Frame(page, bg=BG)
        self.stat_frame.pack(fill="x", padx=32, pady=24)

        self.stat_labels = {}
        stats = [
            ("total_books",      "Total Books",      ACCENT),
            ("total_copies",     "Total Copies",     ACCENT),
            ("available_copies", "Available",        ACCENT2),
            ("active_readers",   "Active Readers",   ACCENT),
            ("borrowed_count",   "Borrowed",         WARN),
            ("overdue_count",    "Overdue",          DANGER),
        ]
        for i, (key, label, color) in enumerate(stats):
            card = tk.Frame(self.stat_frame, bg=CARD, padx=20, pady=16)
            card.grid(row=0, column=i, padx=8, sticky="nsew")
            self.stat_frame.grid_columnconfigure(i, weight=1)
            val_lbl = lbl(card, "–", size=26, bold=True, color=color, bg=CARD)
            val_lbl.pack()
            lbl(card, label, size=9, color=TXT_DIM, bg=CARD).pack()
            self.stat_labels[key] = val_lbl

    def _refresh_dashboard(self):
        try:
            stats = self.loan_svc.get_dashboard_stats()
            for key, lbl_widget in self.stat_labels.items():
                lbl_widget.config(text=str(stats.get(key, "–")))
        except Exception as e:
            messagebox.showerror("DB Error", str(e))

    # ── Books ─────────────────────────────────────────────────────────────

    def _build_books(self, page):
        # Header
        header = tk.Frame(page, bg=BG)
        header.pack(fill="x", padx=32, pady=(28,0))
        lbl(header, "Books", size=18, bold=True).pack(side="left")

        btn_frame = tk.Frame(header, bg=BG)
        btn_frame.pack(side="right")
        styled_btn(btn_frame, "+ Add Book",   self._dlg_add_book,  ACCENT2).pack(side="left", padx=4)
        styled_btn(btn_frame, "+ Add Copies", self._dlg_add_copies, ACCENT).pack(side="left", padx=4)
        styled_btn(btn_frame, "✏ Edit",       self._dlg_edit_book,  ACCENT).pack(side="left", padx=4)
        styled_btn(btn_frame, "🗑 Delete",    self._dlg_del_book,   DANGER).pack(side="left", padx=4)

        # Search bar
        sf = tk.Frame(page, bg=BG)
        sf.pack(fill="x", padx=32, pady=10)
        lbl(sf, "Search:", size=10, color=TXT_DIM).pack(side="left", padx=(0,8))
        self.book_search_var = tk.StringVar()
        e = tk.Entry(sf, textvariable=self.book_search_var, width=32,
                     bg=CARD, fg=TXT, insertbackground=TXT, relief="flat",
                     font=(FONT, 10), bd=6)
        e.pack(side="left")
        styled_btn(sf, "Search", self._refresh_books, ACCENT).pack(side="left", padx=8)
        styled_btn(sf, "Clear",
                   lambda: (self.book_search_var.set(""), self._refresh_books()),
                   CARD).pack(side="left")

        # Table
        cols  = ["ID", "Title", "Author", "Category", "Year", "ISBN", "Copies", "Available"]
        widths= [40, 240, 160, 120, 60, 120, 60, 70]
        tframe, self.book_tree = make_table(page, cols, widths, height=16)
        tframe.pack(fill="both", expand=True, padx=32, pady=(0,20))

    def _refresh_books(self):
        kw = self.book_search_var.get().strip()
        try:
            rows = self.book_svc.search_books(kw) if kw else self.book_svc.get_all_books()
            self.book_tree.delete(*self.book_tree.get_children())
            for r in rows:
                self.book_tree.insert("", "end", iid=str(r["book_id"]), values=(
                    r["book_id"], r["title"], r["author_name"],
                    r["category_name"], r.get("publish_year",""),
                    r.get("isbn",""), r["total_copies"], r["available_copies"]
                ))
        except Exception as e:
            messagebox.showerror("Error", str(e))

    def _selected_book_id(self):
        sel = self.book_tree.selection()
        if not sel:
            messagebox.showwarning("Select", "Please select a book first.")
            return None
        return int(sel[0])

    def _dlg_add_book(self):
        dlg = tk.Toplevel(self); dlg.title("Add Book"); dlg.configure(bg=BG)
        dlg.geometry("420x320"); dlg.grab_set()
        f = tk.Frame(dlg, bg=BG, padx=24, pady=20); f.pack(fill="both", expand=True)
        lbl(f, "Add New Book", size=13, bold=True).grid(row=0, columnspan=2, sticky="w", pady=(0,12))
        title_v   = entry_row(f, "Title",        1)
        author_v  = entry_row(f, "Author",       2)
        cat_v     = entry_row(f, "Category",     3)
        year_v    = entry_row(f, "Publish Year", 4, "2024")
        isbn_v    = entry_row(f, "ISBN",         5)
        copies_v  = entry_row(f, "Copies",       6, "1", width=8)
        f.grid_columnconfigure(1, weight=1)

        def submit():
            try:
                self.book_svc.add_book(
                    title_v.get(), author_v.get(), cat_v.get(),
                    int(year_v.get() or 0), isbn_v.get(), int(copies_v.get() or 1)
                )
                messagebox.showinfo("Success", "Book added!", parent=dlg)
                dlg.destroy(); self._refresh_books()
            except Exception as e:
                messagebox.showerror("Error", str(e), parent=dlg)

        styled_btn(f, "Add Book", submit, ACCENT2).grid(row=7, column=1, sticky="e", pady=12)

    def _dlg_edit_book(self):
        bid = self._selected_book_id()
        if not bid: return
        sel = self.book_tree.item(str(bid))["values"]

        dlg = tk.Toplevel(self); dlg.title("Edit Book"); dlg.configure(bg=BG)
        dlg.geometry("420x300"); dlg.grab_set()
        f = tk.Frame(dlg, bg=BG, padx=24, pady=20); f.pack(fill="both", expand=True)
        lbl(f, "Edit Book", size=13, bold=True).grid(row=0, columnspan=2, sticky="w", pady=(0,12))
        title_v  = entry_row(f, "Title",        1, sel[1])
        author_v = entry_row(f, "Author",       2, sel[2])
        cat_v    = entry_row(f, "Category",     3, sel[3])
        year_v   = entry_row(f, "Publish Year", 4, sel[4])
        isbn_v   = entry_row(f, "ISBN",         5, sel[5])
        f.grid_columnconfigure(1, weight=1)

        def submit():
            try:
                self.book_svc.update_book(
                    bid, title_v.get(), author_v.get(), cat_v.get(),
                    int(year_v.get() or 0), isbn_v.get()
                )
                messagebox.showinfo("Success", "Book updated!", parent=dlg)
                dlg.destroy(); self._refresh_books()
            except Exception as e:
                messagebox.showerror("Error", str(e), parent=dlg)

        styled_btn(f, "Save Changes", submit, ACCENT).grid(row=6, column=1, sticky="e", pady=12)

    def _dlg_del_book(self):
        bid = self._selected_book_id()
        if not bid: return
        if messagebox.askyesno("Delete", f"Delete book ID {bid}? This removes all its copies."):
            try:
                self.book_svc.delete_book(bid)
                self._refresh_books()
            except Exception as e:
                messagebox.showerror("Error", str(e))

    def _dlg_add_copies(self):
        bid = self._selected_book_id()
        if not bid: return
        n = simpledialog.askinteger("Add Copies", "How many copies to add?",
                                    minvalue=1, maxvalue=50, parent=self)
        if n:
            try:
                self.book_svc.add_copies(bid, n)
                messagebox.showinfo("Success", f"{n} copies added.")
                self._refresh_books()
            except Exception as e:
                messagebox.showerror("Error", str(e))

    # ── Readers ───────────────────────────────────────────────────────────

    def _build_readers(self, page):
        header = tk.Frame(page, bg=BG)
        header.pack(fill="x", padx=32, pady=(28,0))
        lbl(header, "Readers", size=18, bold=True).pack(side="left")
        btn_f = tk.Frame(header, bg=BG); btn_f.pack(side="right")
        styled_btn(btn_f, "+ Register", self._dlg_add_reader, ACCENT2).pack(side="left", padx=4)
        styled_btn(btn_f, "✏ Edit",    self._dlg_edit_reader, ACCENT).pack(side="left", padx=4)
        styled_btn(btn_f, "🗑 Delete", self._dlg_del_reader,  DANGER).pack(side="left", padx=4)

        sf = tk.Frame(page, bg=BG); sf.pack(fill="x", padx=32, pady=10)
        lbl(sf, "Search:", size=10, color=TXT_DIM).pack(side="left", padx=(0,8))
        self.reader_search_var = tk.StringVar()
        tk.Entry(sf, textvariable=self.reader_search_var, width=28,
                 bg=CARD, fg=TXT, insertbackground=TXT, relief="flat",
                 font=(FONT, 10), bd=6).pack(side="left")
        styled_btn(sf, "Search", self._refresh_readers, ACCENT).pack(side="left", padx=8)
        styled_btn(sf, "Clear",
                   lambda: (self.reader_search_var.set(""), self._refresh_readers()),
                   CARD).pack(side="left")

        cols   = ["ID", "Name", "Phone", "Address", "Status"]
        widths = [40, 200, 120, 280, 80]
        tf, self.reader_tree = make_table(page, cols, widths, height=18)
        tf.pack(fill="both", expand=True, padx=32, pady=(0,20))

    def _refresh_readers(self):
        kw = self.reader_search_var.get().strip()
        try:
            rows = self.reader_svc.search_readers(kw) if kw else self.reader_svc.get_all_readers()
            self.reader_tree.delete(*self.reader_tree.get_children())
            for r in rows:
                tag = "blocked" if r["status"] == "BLOCKED" else ""
                self.reader_tree.insert("", "end", iid=str(r["reader_id"]), tags=(tag,), values=(
                    r["reader_id"], r["reader_name"], r.get("phone",""),
                    r.get("address",""), r["status"]
                ))
            self.reader_tree.tag_configure("blocked", foreground=DANGER)
        except Exception as e:
            messagebox.showerror("Error", str(e))

    def _selected_reader_id(self):
        sel = self.reader_tree.selection()
        if not sel:
            messagebox.showwarning("Select", "Please select a reader first.")
            return None
        return int(sel[0])

    def _dlg_add_reader(self):
        dlg = tk.Toplevel(self); dlg.title("Register Reader")
        dlg.configure(bg=BG); dlg.geometry("380x240"); dlg.grab_set()
        f = tk.Frame(dlg, bg=BG, padx=24, pady=20); f.pack(fill="both", expand=True)
        lbl(f, "Register New Reader", size=13, bold=True).grid(row=0, columnspan=2, sticky="w", pady=(0,12))
        name_v  = entry_row(f, "Full Name", 1)
        phone_v = entry_row(f, "Phone",     2)
        addr_v  = entry_row(f, "Address",   3)
        f.grid_columnconfigure(1, weight=1)

        def submit():
            try:
                self.reader_svc.register_reader(name_v.get(), phone_v.get(), addr_v.get())
                messagebox.showinfo("Success", "Reader registered!", parent=dlg)
                dlg.destroy(); self._refresh_readers()
            except Exception as e:
                messagebox.showerror("Error", str(e), parent=dlg)

        styled_btn(f, "Register", submit, ACCENT2).grid(row=4, column=1, sticky="e", pady=12)

    def _dlg_edit_reader(self):
        rid = self._selected_reader_id()
        if not rid: return
        sel = self.reader_tree.item(str(rid))["values"]

        dlg = tk.Toplevel(self); dlg.title("Edit Reader")
        dlg.configure(bg=BG); dlg.geometry("380x280"); dlg.grab_set()
        f = tk.Frame(dlg, bg=BG, padx=24, pady=20); f.pack(fill="both", expand=True)
        lbl(f, "Edit Reader", size=13, bold=True).grid(row=0, columnspan=2, sticky="w", pady=(0,12))
        name_v  = entry_row(f, "Full Name", 1, sel[1])
        phone_v = entry_row(f, "Phone",     2, sel[2])
        addr_v  = entry_row(f, "Address",   3, sel[3])
        lbl(f, "Status", size=10, color=TXT_DIM).grid(row=4, column=0, sticky="w", pady=4)
        status_v = tk.StringVar(value=sel[4])
        ttk.Combobox(f, textvariable=status_v,
                     values=["ACTIVE","BLOCKED"], state="readonly",
                     font=(FONT, 10)).grid(row=4, column=1, sticky="ew", pady=4)
        f.grid_columnconfigure(1, weight=1)

        def submit():
            try:
                self.reader_svc.update_reader(rid, name_v.get(), phone_v.get(),
                                              addr_v.get(), status_v.get())
                messagebox.showinfo("Success", "Reader updated!", parent=dlg)
                dlg.destroy(); self._refresh_readers()
            except Exception as e:
                messagebox.showerror("Error", str(e), parent=dlg)

        styled_btn(f, "Save", submit, ACCENT).grid(row=5, column=1, sticky="e", pady=12)

    def _dlg_del_reader(self):
        rid = self._selected_reader_id()
        if not rid: return
        if messagebox.askyesno("Delete", f"Delete reader ID {rid}?"):
            try:
                self.reader_svc.delete_reader(rid)
                self._refresh_readers()
            except Exception as e:
                messagebox.showerror("Error", str(e))

    # ── Borrow ────────────────────────────────────────────────────────────

    def _build_borrow(self, page):
        wrap = tk.Frame(page, bg=BG)
        wrap.place(relx=0.5, rely=0.5, anchor="center")

        card = tk.Frame(wrap, bg=CARD, padx=36, pady=36)
        card.pack()
        lbl(card, "➕  Borrow a Book", size=16, bold=True, bg=CARD).grid(
            row=0, columnspan=2, sticky="w", pady=(0,20))

        self.borrow_phone_v = entry_row(card, "Reader Phone", 1, width=28)
        self.borrow_title_v = entry_row(card, "Book Title",   2, width=28)
        lbl(card, "Loan Days", size=10, color=TXT_DIM, bg=CARD).grid(
            row=3, column=0, sticky="w", pady=4)
        self.borrow_days_v = tk.StringVar(value="14")
        tk.Entry(card, textvariable=self.borrow_days_v, width=8,
                 bg=BG, fg=TXT, insertbackground=TXT, relief="flat",
                 font=(FONT, 10), bd=4).grid(row=3, column=1, sticky="w", pady=4)

        card.grid_columnconfigure(1, weight=1)

        self.borrow_result = lbl(card, "", size=11, color=ACCENT2, bg=CARD)
        self.borrow_result.grid(row=5, columnspan=2, sticky="w", pady=(8,0))

        styled_btn(card, "✅  Confirm Borrow", self._do_borrow, ACCENT2,
                   width=22).grid(row=4, column=1, sticky="e", pady=16)

    def _do_borrow(self):
        try:
            msg = self.loan_svc.borrow_book(
                self.borrow_phone_v.get(),
                self.borrow_title_v.get(),
                int(self.borrow_days_v.get() or 14)
            )
            self.borrow_result.config(text=msg, fg=ACCENT2)
            self.borrow_phone_v.set(""); self.borrow_title_v.set("")
        except ValueError as e:
            self.borrow_result.config(text=f"❌ {e}", fg=DANGER)

    # ── Return ────────────────────────────────────────────────────────────

    def _build_return(self, page):
        wrap = tk.Frame(page, bg=BG)
        wrap.place(relx=0.5, rely=0.5, anchor="center")

        card = tk.Frame(wrap, bg=CARD, padx=36, pady=36)
        card.pack()
        lbl(card, "↩  Return a Book", size=16, bold=True, bg=CARD).grid(
            row=0, columnspan=2, sticky="w", pady=(0,20))

        self.return_barcode_v = entry_row(card, "Book Barcode", 1, width=28)
        card.grid_columnconfigure(1, weight=1)

        self.return_result = lbl(card, "", size=11, color=ACCENT2, bg=CARD)
        self.return_result.grid(row=3, columnspan=2, sticky="w", pady=(8,0))

        styled_btn(card, "↩  Confirm Return", self._do_return, ACCENT,
                   width=22).grid(row=2, column=1, sticky="e", pady=16)

    def _do_return(self):
        try:
            result = self.loan_svc.return_book(self.return_barcode_v.get())
            color  = WARN if result["overdue_days"] > 0 else ACCENT2
            self.return_result.config(text=result["message"], fg=color)
            self.return_barcode_v.set("")
        except ValueError as e:
            self.return_result.config(text=f"❌ {e}", fg=DANGER)

    # ── Active Loans ──────────────────────────────────────────────────────

    def _build_loans(self, page):
        header = tk.Frame(page, bg=BG)
        header.pack(fill="x", padx=32, pady=(28,0))
        lbl(header, "Active Loans", size=18, bold=True).pack(side="left")
        styled_btn(header, "🔄 Refresh", self._refresh_loans, ACCENT).pack(side="right")

        cols   = ["Loan ID","Reader","Phone","Book","Barcode","Borrowed","Due","Overdue Days","Status"]
        widths = [60, 150, 110, 200, 110, 90, 90, 100, 80]
        tf, self.loans_tree = make_table(page, cols, widths, height=20)
        tf.pack(fill="both", expand=True, padx=32, pady=(12,20))

    def _refresh_loans(self):
        try:
            rows = self.loan_svc.get_active_loans()
            self.loans_tree.delete(*self.loans_tree.get_children())
            for r in rows:
                od = r.get("overdue_days", 0) or 0
                tag = "overdue" if od > 0 else ""
                self.loans_tree.insert("", "end", tags=(tag,), values=(
                    r["loan_id"], r["reader_name"], r.get("phone",""),
                    r["book_title"], r["barcode"],
                    r["borrow_date"], r["due_date"],
                    f"{od} days" if od > 0 else "On time",
                    r["status"]
                ))
            self.loans_tree.tag_configure("overdue", foreground=WARN)
        except Exception as e:
            messagebox.showerror("Error", str(e))

    # ── Overdue ───────────────────────────────────────────────────────────

    def _build_overdue(self, page):
        header = tk.Frame(page, bg=BG)
        header.pack(fill="x", padx=32, pady=(28,0))
        lbl(header, "⚠️  Overdue Books", size=18, bold=True, color=WARN).pack(side="left")
        styled_btn(header, "🔄 Refresh", self._refresh_overdue, ACCENT).pack(side="right")

        cols   = ["Reader","Phone","Book","Barcode","Borrowed","Due","Overdue Days"]
        widths = [160, 110, 220, 110, 90, 90, 100]
        tf, self.overdue_tree = make_table(page, cols, widths, height=20)
        tf.pack(fill="both", expand=True, padx=32, pady=(12,20))

    def _refresh_overdue(self):
        try:
            rows = self.overdue_tree.get_children()
            self.overdue_tree.delete(*rows)
            for r in self.loan_svc.get_overdue_loans():
                self.overdue_tree.insert("", "end", values=(
                    r["reader_name"], r.get("phone",""), r["book_title"],
                    r["barcode"], r["borrow_date"], r["due_date"],
                    f'{r["overdue_days"]} days'
                ))
        except Exception as e:
            messagebox.showerror("Error", str(e))

    # ── History ───────────────────────────────────────────────────────────

    def _build_history(self, page):
        lbl(page, "Loan History", size=18, bold=True).pack(anchor="w", padx=32, pady=(28,8))

        cols   = ["Loan ID","Reader","Phone","Book","Barcode","Borrowed","Due","Returned","Status","Late Days"]
        widths = [60, 150, 110, 190, 110, 90, 90, 90, 80, 80]
        tf, self.history_tree = make_table(page, cols, widths, height=20)
        tf.pack(fill="both", expand=True, padx=32, pady=(0,20))

    def _refresh_history(self):
        try:
            rows = self.loan_svc.get_loan_history()
            self.history_tree.delete(*self.history_tree.get_children())
            for r in rows:
                self.history_tree.insert("", "end", values=(
                    r["loan_id"], r["reader_name"], r.get("phone",""),
                    r["book_title"], r["barcode"],
                    r["borrow_date"], r["due_date"],
                    r.get("return_date","–"),
                    r["status"],
                    r.get("overdue_days", 0)
                ))
        except Exception as e:
            messagebox.showerror("Error", str(e))


# ── Entry point ────────────────────────────────────────────────────────────

def main():
    app = LibraryApp()
    app.mainloop()


if __name__ == "__main__":
    main()
