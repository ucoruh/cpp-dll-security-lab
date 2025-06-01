using System;
using System.IO;
using System.Runtime.InteropServices;

namespace CSharpExplicitLoader
{
    internal class Program
    {
        // Windows API fonksiyonları için P/Invoke tanımları
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr LoadLibrary(string libname);

        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern bool FreeLibrary(IntPtr hModule);

        [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
        private static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

        // Dinamik olarak yüklenecek fonksiyon tiplerini tanımlama
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate int MatematikToplaDelegate(int a, int b);

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate int MatematikCikarDelegate(int a, int b);

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate int MatematikCarpDelegate(int a, int b);

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate double MatematikBolDelegate(int a, int b);

        static void Main(string[] args)
        {
            Console.WriteLine("C# DLL İstemcisi (Explisit Yükleme)");
            Console.WriteLine("====================================\n");
            
            // DLL yolunu belirle
            string dllPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "matematik.dll");
            Console.WriteLine($"DLL Yolu: {dllPath}");

            // DLL'i yükle
            IntPtr dllHandle = LoadLibrary(dllPath);
            if (dllHandle == IntPtr.Zero)
            {
                int errorCode = Marshal.GetLastWin32Error();
                Console.WriteLine($"DLL yüklenirken hata oluştu! Hata kodu: {errorCode}");
                return;
            }

            Console.WriteLine("DLL başarıyla yüklendi.");
            Console.WriteLine("Fonksiyonlar çözülüyor...");

            try
            {
                // Fonksiyon adreslerini al
                IntPtr toplaPtr = GetProcAddress(dllHandle, "topla");
                IntPtr cikarPtr = GetProcAddress(dllHandle, "cikar");
                IntPtr carpPtr = GetProcAddress(dllHandle, "carp");
                IntPtr bolPtr = GetProcAddress(dllHandle, "bol");

                // Fonksiyon adreslerini delegelere çevir
                MatematikToplaDelegate topla = Marshal.GetDelegateForFunctionPointer<MatematikToplaDelegate>(toplaPtr);
                MatematikCikarDelegate cikar = Marshal.GetDelegateForFunctionPointer<MatematikCikarDelegate>(cikarPtr);
                MatematikCarpDelegate carp = Marshal.GetDelegateForFunctionPointer<MatematikCarpDelegate>(carpPtr);
                MatematikBolDelegate bol = Marshal.GetDelegateForFunctionPointer<MatematikBolDelegate>(bolPtr);

                Console.WriteLine("Fonksiyonlar başarıyla çözüldü.");
                Console.WriteLine("İşlemler gerçekleştiriliyor...\n");

                // Fonksiyonları çağır
                int a = 10;
                int b = 5;

                Console.WriteLine($"Topla: {a} + {b} = {topla(a, b)}");
                Console.WriteLine($"Çıkar: {a} - {b} = {cikar(a, b)}");
                Console.WriteLine($"Çarp:  {a} * {b} = {carp(a, b)}");
                Console.WriteLine($"Böl:   {a} / {b} = {bol(a, b)}");

                // 0'a bölme testi
                Console.WriteLine("\nSıfıra bölme testi:");
                Console.WriteLine($"Böl: 10 / 0 = {bol(10, 0)}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Hata: {ex.Message}");
                if (ex.InnerException != null)
                    Console.WriteLine($"İç Hata: {ex.InnerException.Message}");
            }
            finally
            {
                // DLL'i serbest bırak
                Console.WriteLine("\nDLL'i serbest bırakılıyor...");
                if (FreeLibrary(dllHandle))
                {
                    Console.WriteLine("DLL başarıyla serbest bırakıldı.");
                }
                else
                {
                    int errorCode = Marshal.GetLastWin32Error();
                    Console.WriteLine($"DLL serbest bırakılırken hata oluştu! Hata kodu: {errorCode}");
                }
            }

            Console.WriteLine("\nDevam etmek için bir tuşa basın...");
            Console.ReadKey();
        }
    }
} 