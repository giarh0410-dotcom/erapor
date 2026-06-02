toastr.options = {
  "closeButton": true,
  "debug": false,
  "newestOnTop": false,
  "progressBar": false,
  "positionClass": "toast-top-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}
pesan = function(l, f) {
	switch (l) {
		case "success":
			toastr.success(f, "Sukses");
			break;
		case "info":
			toastr.info(f, "Info");
			break;
		case "warning":
			toastr.warning(f, "Peringatan");
			break;
		case "error":
			toastr.error(f, "Terjadi Kesalahan");
			break;
		default:
			toastr.error(f, "Terjadi Kesalahan")
	}
};
pesanstr = function(l) {
	switch (l) {
		case "created":
			l = "Data Anda telah disimpan !";
			break;
		case "not_created":
			l = "Terjadi kesalahan dalam menyimpan data Anda !";
			break;
		case "updated":
			l = "Data Anda telah diperbaharui !";
			break;
		case "not_updated":
			l = "Data Anda tidak dapat diperbaharui !";
			break;
		case "404":
			l = "Halaman tidak ditemukan !";
			break;
		case "deleted":
			l = "Data Anda telah dihapus !";
			break;
		case "not_deleted":
			l = "Terjadi kesalahan dalam menghapus data Anda !";
			break;
		case "restored":
			l = "Data Anda telah dikembalikan !";
			break;
		case "not_restored":
			l = "Terjadi kesalahan dalam mengembalikan data Anda !";
			break;
		case "not_selected":
			l = "Tidak ada item terpilih !";
			break;
		case "existed":
			l = "Data sudah tersedia !";
			break;
		case "empty":
			l = "Data tidak tersedia !";
			break;
		case "required":
			l = "Field harus diisi !";
			break;
		case "not_numeric":
			l = "ID bukan tipe angka";
			break;
		case "keyword_empty":
			l = "Kata kunci pencarian tidak boleh kosong, dan minimal 3 karakter !";
			break;
		case "no_changed":
			l = "Tidak ada data yang berubah !";
			break;
		case "logged_in":
			l ="Log In berhasil. Halaman akan dialihkan dalam 2 detik. Jika tidak dialihkan, silahkan refresh browser Anda!</a>";
			break;
		case "not_logged_in":
			l = "Log In gagal. Nama akun dan/atau kata sandi yang Anda masukan salah.";
			break;
		case "has_logged":
			l = "Log In gagal. Your Login Is Locked, please Reset Login.";
			break;			
		case "not_active":
			l = "Log In gagal. Akun anda di non aktifkan.";
			break;
		case "forbidden":
			l = "Akses ditolak!";
			break;
		case "extracted":
			l = "Tema berhasil diextract";
			break;
		case "not_extracted":
			l = "Tema gagal diextract"
	}
	return l
};