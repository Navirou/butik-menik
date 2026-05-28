-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 22 Bulan Mei 2026 pada 10.08
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `butik_menik`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `materials`
--

CREATE TABLE `materials` (
  `id` int(10) UNSIGNED NOT NULL,
  `supplier_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `current_stock` decimal(10,2) NOT NULL DEFAULT 0.00,
  `min_stock` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `materials`
--

INSERT INTO `materials` (`id`, `supplier_id`, `name`, `unit`, `current_stock`, `min_stock`, `created_at`) VALUES
(1, 9, 'Kain Katun Putih', 'meter', 45.50, 20.00, '2026-04-23 20:31:38'),
(2, 10, 'Benang Sutra Biru', 'spul', 180.00, 50.00, '2026-04-23 20:31:38'),
(3, 10, 'Kancing Silver', 'pcs', 420.00, 100.00, '2026-04-23 20:31:38'),
(4, 9, 'Kain Batik Parang', 'meter', 12.00, 10.00, '2026-04-23 20:31:38');

-- --------------------------------------------------------

--
-- Struktur dari tabel `material_requests`
--

CREATE TABLE `material_requests` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_code` varchar(20) NOT NULL,
  `material_id` int(10) UNSIGNED NOT NULL,
  `requested_by` int(10) UNSIGNED NOT NULL,
  `supplier_id` int(10) UNSIGNED NOT NULL,
  `qty_requested` decimal(10,2) NOT NULL,
  `qty_received` decimal(10,2) DEFAULT NULL,
  `priority` enum('regular','urgent') NOT NULL DEFAULT 'regular',
  `status` enum('pending','accepted','shipped','received','cancelled') NOT NULL DEFAULT 'pending',
  `invoice_file` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `supplier_note` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `material_requests`
--

INSERT INTO `material_requests` (`id`, `request_code`, `material_id`, `requested_by`, `supplier_id`, `qty_requested`, `qty_received`, `priority`, `status`, `invoice_file`, `notes`, `supplier_note`, `created_at`, `updated_at`) VALUES
(1, 'REQ-2026-001', 2, 6, 9, 3.00, NULL, 'regular', 'pending', NULL, '', NULL, '2026-04-25 21:02:35', '2026-04-25 21:02:35'),
(2, 'REQ-2026-002', 3, 6, 10, 7.00, NULL, 'urgent', 'pending', NULL, '', NULL, '2026-04-25 21:04:36', '2026-04-25 21:04:36'),
(3, 'REQ-2026-003', 2, 6, 10, 5.00, NULL, 'regular', 'pending', NULL, '', NULL, '2026-04-25 21:11:24', '2026-04-25 21:11:24');

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` text NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `ref_id` int(10) UNSIGNED DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `body`, `type`, `ref_id`, `is_read`, `created_at`) VALUES
(5, 5, 'Pembayaran Terverifikasi', 'Pembayaran dp kamu telah dikonfirmasi.', 'payment', 1, 0, '2026-04-23 23:58:12'),
(6, 6, 'Pesanan Baru Masuk', 'Pesanan BSN005042543 dari Aditya Putra menunggu konfirmasi.', 'order_update', 2, 0, '2026-04-25 21:10:07'),
(7, 6, 'Bukti Pembayaran Baru', 'Bukti DP dari Aditya Putra untuk pesanan BSN005042543 menunggu verifikasi.', 'payment', 2, 0, '2026-04-25 21:10:17'),
(8, 5, 'Pembayaran Terverifikasi', 'Pembayaran dp kamu telah dikonfirmasi.', 'payment', 2, 0, '2026-04-25 21:11:03'),
(9, 5, 'Update Produksi Pesanan', 'Tahap: DP Diverifikasi (52% selesai).', 'order_update', 2, 0, '2026-04-25 21:12:33'),
(10, 5, 'Update Produksi Pesanan', 'Tahap: DP Diverifikasi (100% selesai).', 'order_update', 2, 0, '2026-04-25 21:12:47'),
(11, 5, 'Update Produksi Pesanan', 'Tahap: DP Diverifikasi (49% selesai).', 'order_update', 1, 0, '2026-04-25 21:13:03'),
(12, 5, 'Update Produksi Pesanan', 'Tahap: QC (100% selesai).', 'order_update', 2, 0, '2026-04-27 20:35:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `orders`
--

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_code` varchar(20) NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `staff_id` int(10) UNSIGNED DEFAULT NULL,
  `size` varchar(30) DEFAULT NULL,
  `fabric_type` varchar(100) DEFAULT NULL,
  `color` varchar(80) DEFAULT NULL,
  `model_description` text DEFAULT NULL,
  `design_file` varchar(255) DEFAULT NULL,
  `qty` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `total_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `dp_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `dp_percentage` tinyint(3) UNSIGNED NOT NULL DEFAULT 50,
  `status` enum('menunggu_konfirmasi','dikonfirmasi','ditolak','dp_menunggu','dp_diverifikasi','pemeriksaan_stok','produksi','qc','jadwal_ambil','selesai','revisi','dibatalkan') NOT NULL DEFAULT 'menunggu_konfirmasi',
  `estimated_done` date DEFAULT NULL,
  `pickup_date` date DEFAULT NULL,
  `pickup_time_start` time DEFAULT NULL,
  `pickup_time_end` time DEFAULT NULL,
  `owner_notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `orders`
--

INSERT INTO `orders` (`id`, `order_code`, `customer_id`, `product_id`, `staff_id`, `size`, `fabric_type`, `color`, `model_description`, `design_file`, `qty`, `total_price`, `dp_amount`, `dp_percentage`, `status`, `estimated_done`, `pickup_date`, `pickup_time_start`, `pickup_time_end`, `owner_notes`, `created_at`, `updated_at`) VALUES
(1, 'BSN005042389', 5, 4, NULL, 'XL', 'katun', 'biru', 'adalah pokoknya', 'dsn_69ea353f9a13c.jpg', 1, 280000.00, 140000.00, 50, 'dp_diverifikasi', '2026-05-07', NULL, NULL, NULL, NULL, '2026-04-23 22:05:35', '2026-04-23 23:58:12'),
(2, 'BSN005042543', 5, 3, NULL, 'M', 'Sutra', 'Navy', '', 'dsn_69eccb3ef3a40.jpg', 1, 500000.00, 250000.00, 50, 'qc', '2026-05-09', NULL, NULL, NULL, NULL, '2026-04-25 21:10:07', '2026-04-27 20:35:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `payments`
--

CREATE TABLE `payments` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `type` enum('dp','pelunasan') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `method` varchar(50) DEFAULT NULL,
  `proof_file` varchar(255) DEFAULT NULL,
  `status` enum('menunggu','diverifikasi','ditolak') NOT NULL DEFAULT 'menunggu',
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `type`, `amount`, `method`, `proof_file`, `status`, `verified_by`, `verified_at`, `notes`, `created_at`) VALUES
(1, 1, 'dp', 140000.00, 'Bank Mandiri', 'pay_69ea354be1daf.png', 'menunggu', NULL, NULL, '', '2026-04-23 22:05:47'),
(2, 1, 'dp', 140000.00, 'Bank Mandiri', 'pay_69ea3555ce56d.png', 'ditolak', 5, '2026-04-23 23:58:15', '', '2026-04-23 22:05:57'),
(3, 1, 'dp', 140000.00, 'Bank Mandiri', 'pay_69ea3a55afb54.png', 'diverifikasi', 5, '2026-04-23 23:58:12', '', '2026-04-23 22:27:17'),
(4, 2, 'dp', 250000.00, 'Bank BRI', 'pay_69eccb49ee6f3.png', 'diverifikasi', 6, '2026-04-25 21:11:03', '', '2026-04-25 21:10:17');

-- --------------------------------------------------------

--
-- Struktur dari tabel `production_logs`
--

CREATE TABLE `production_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `stage_id` tinyint(3) UNSIGNED NOT NULL,
  `updated_by` int(10) UNSIGNED NOT NULL,
  `progress` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `production_logs`
--

INSERT INTO `production_logs` (`id`, `order_id`, `stage_id`, `updated_by`, `progress`, `notes`, `created_at`) VALUES
(1, 2, 1, 7, 52, '', '2026-04-25 21:12:33'),
(2, 2, 1, 7, 100, '', '2026-04-25 21:12:47'),
(3, 1, 1, 7, 49, '', '2026-04-25 21:13:03'),
(4, 2, 6, 7, 100, '', '2026-04-27 20:35:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `production_stages`
--

CREATE TABLE `production_stages` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` enum('dp_verified','stock_check','cutting','sewing','finishing','qc','done') NOT NULL,
  `label` varchar(60) NOT NULL,
  `seq` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `production_stages`
--

INSERT INTO `production_stages` (`id`, `name`, `label`, `seq`) VALUES
(1, 'dp_verified', 'DP Diverifikasi', 1),
(2, 'stock_check', 'Pemeriksaan Stok', 2),
(3, 'cutting', 'Pemotongan', 3),
(4, 'sewing', 'Penjahitan', 4),
(5, 'finishing', 'Finishing', 5),
(6, 'qc', 'Quality Control', 6),
(7, 'done', 'Selesai', 7);

-- --------------------------------------------------------

--
-- Struktur dari tabel `products`
--

CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `category_id` smallint(5) UNSIGNED DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `base_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `image` varchar(255) DEFAULT NULL,
  `is_custom` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `description`, `base_price`, `image`, `is_custom`, `is_active`, `created_at`) VALUES
(1, 1, 'Kemeja Batik Custom', 'kemeja-batik-parang', 350000.00, 'kemeja-batik-custom.png', 1, 1, '2026-04-23 20:31:38'),
(2, 2, 'Gamis Syari Polos', 'gamis-syari-polos', 450000.00, 'gamis-syari-polos.png', 1, 1, '2026-04-23 20:31:38'),
(3, 3, 'Blazer Slim Fit', 'blazer-slim-fit', 500000.00, 'blazer-slim-fit.png', 1, 1, '2026-04-23 20:31:38'),
(4, 1, 'Kemeja Batik Parang', 'kemeja-batik-custom', 280000.00, 'kemeja-batik-parang.png', 0, 1, '2026-04-23 20:31:38');

-- --------------------------------------------------------

--
-- Struktur dari tabel `product_categories`
--

CREATE TABLE `product_categories` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `name` varchar(80) NOT NULL,
  `slug` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `product_categories`
--

INSERT INTO `product_categories` (`id`, `name`, `slug`) VALUES
(1, 'Kemeja Batik', 'kemeja-batik'),
(2, 'Gamis Custom', 'gamis-custom'),
(3, 'Blazer Formal', 'blazer-formal'),
(4, 'Celana Formal', 'celana-formal');

-- --------------------------------------------------------

--
-- Struktur dari tabel `qc_results`
--

CREATE TABLE `qc_results` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `checked_by` int(10) UNSIGNED NOT NULL,
  `passed` tinyint(1) NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `checked_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `revisions`
--

CREATE TABLE `revisions` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `requested_by` int(10) UNSIGNED NOT NULL,
  `description` text NOT NULL,
  `status` enum('open','in_progress','resolved','rejected') NOT NULL DEFAULT 'open',
  `handled_by` int(10) UNSIGNED DEFAULT NULL,
  `handler_note` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `roles`
--

CREATE TABLE `roles` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` enum('owner','staff','supplier','customer') NOT NULL,
  `label` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `roles`
--

INSERT INTO `roles` (`id`, `name`, `label`) VALUES
(1, 'owner', 'Owner / Admin'),
(2, 'staff', 'Staff Produksi'),
(3, 'supplier', 'Supplier'),
(4, 'customer', 'Pelanggan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `stock_ledger`
--

CREATE TABLE `stock_ledger` (
  `id` int(10) UNSIGNED NOT NULL,
  `material_id` int(10) UNSIGNED NOT NULL,
  `type` enum('in','out','adjustment') NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `reference` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `recorded_by` int(10) UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `role_id`, `name`, `email`, `phone`, `password`, `avatar`, `is_active`, `created_at`, `updated_at`) VALUES
(5, 4, 'Aditya Putra', 'adityaujang@gmail.com', '08976565628', '$2y$10$zMXiKSq2YpJU2CNLTCg1p.ZIJ/wghxWyPQvu3UXajJ..7X3xYNfS.', NULL, 1, '2026-04-23 22:03:09', '2026-04-25 16:06:50'),
(6, 1, 'Andreas', 'ownerbisnis@butikmenik.id', '0878999756', '$2y$10$TBBB1jwglNXLLOqEhUPsfOuDmgTP4PV46ktlpFl9.vzpohlU/IIgW', NULL, 1, '2026-04-25 16:02:05', '2026-04-25 16:02:29'),
(7, 2, 'Yanti', 'staffbisnis@butikmenik.id', '089767899762', '$2y$10$VV/Mufn78Yu7OCrDzR1fEeEJGluwDmd6XfVrf7QaAKxFq02f7.RFu', NULL, 1, '2026-04-25 16:03:34', '2026-04-25 16:03:52'),
(8, 3, 'Yanto', 'supplierbisnis@butikmenik.id', '089678786546', '$2y$10$SK4px9vPVYfjzHLyRStSvOnQU0Z6uytlbqGhbxCiJvD.mVtt8yg1y', NULL, 1, '2026-04-25 16:06:14', '2026-04-25 21:28:10'),
(9, 3, 'Kain Emas', 'kainemas@butikmenik.id', '08987776578', '$2y$10$lypKsQ0mAfesGKqNKo0rSebcY/ImGX4R1rE/yN77dEyIkSkaemGNG', NULL, 1, '2026-04-25 21:01:45', '2026-04-25 21:01:45'),
(10, 3, 'Kain Dewa 99', 'dewa99@butikmenik.id', '087898776577', '$2y$10$/EmwEffOBb0Hx6P7DRV86e9.OnXB6pBzG1Vt50BrO7GqA8ahDmuyu', NULL, 1, '2026-04-25 21:03:54', '2026-04-27 21:05:14');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `materials`
--
ALTER TABLE `materials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indeks untuk tabel `material_requests`
--
ALTER TABLE `material_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `request_code` (`request_code`),
  ADD KEY `material_id` (`material_id`),
  ADD KEY `requested_by` (`requested_by`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indeks untuk tabel `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_code` (`order_code`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `staff_id` (`staff_id`);

--
-- Indeks untuk tabel `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `verified_by` (`verified_by`);

--
-- Indeks untuk tabel `production_logs`
--
ALTER TABLE `production_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `stage_id` (`stage_id`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indeks untuk tabel `production_stages`
--
ALTER TABLE `production_stages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indeks untuk tabel `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indeks untuk tabel `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indeks untuk tabel `qc_results`
--
ALTER TABLE `qc_results`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_id` (`order_id`),
  ADD KEY `checked_by` (`checked_by`);

--
-- Indeks untuk tabel `revisions`
--
ALTER TABLE `revisions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `requested_by` (`requested_by`),
  ADD KEY `handled_by` (`handled_by`);

--
-- Indeks untuk tabel `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indeks untuk tabel `stock_ledger`
--
ALTER TABLE `stock_ledger`
  ADD PRIMARY KEY (`id`),
  ADD KEY `material_id` (`material_id`),
  ADD KEY `recorded_by` (`recorded_by`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `materials`
--
ALTER TABLE `materials`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `material_requests`
--
ALTER TABLE `material_requests`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `production_logs`
--
ALTER TABLE `production_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `production_stages`
--
ALTER TABLE `production_stages`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `products`
--
ALTER TABLE `products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `qc_results`
--
ALTER TABLE `qc_results`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `revisions`
--
ALTER TABLE `revisions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `roles`
--
ALTER TABLE `roles`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `stock_ledger`
--
ALTER TABLE `stock_ledger`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `materials`
--
ALTER TABLE `materials`
  ADD CONSTRAINT `materials_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `material_requests`
--
ALTER TABLE `material_requests`
  ADD CONSTRAINT `material_requests_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `material_requests_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `material_requests_ibfk_3` FOREIGN KEY (`supplier_id`) REFERENCES `users` (`id`);

--
-- Ketidakleluasaan untuk tabel `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `production_logs`
--
ALTER TABLE `production_logs`
  ADD CONSTRAINT `production_logs_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `production_logs_ibfk_2` FOREIGN KEY (`stage_id`) REFERENCES `production_stages` (`id`),
  ADD CONSTRAINT `production_logs_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

--
-- Ketidakleluasaan untuk tabel `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `qc_results`
--
ALTER TABLE `qc_results`
  ADD CONSTRAINT `qc_results_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `qc_results_ibfk_2` FOREIGN KEY (`checked_by`) REFERENCES `users` (`id`);

--
-- Ketidakleluasaan untuk tabel `revisions`
--
ALTER TABLE `revisions`
  ADD CONSTRAINT `revisions_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `revisions_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `revisions_ibfk_3` FOREIGN KEY (`handled_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `stock_ledger`
--
ALTER TABLE `stock_ledger`
  ADD CONSTRAINT `stock_ledger_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`),
  ADD CONSTRAINT `stock_ledger_ibfk_2` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`);

--
-- Ketidakleluasaan untuk tabel `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
