using System;
using System.Collections.Generic;
using System.Net;
using System.IO;
using System.Threading.Tasks;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;

namespace ConsoleApp1
{
	class Program
	{
		static void Main()
		{
			Console.WriteLine("============================================================");
			Console.WriteLine("htmlを入力するとhref/srcを抜き出し、ファイルをダウンロードします。");
			Console.WriteLine("============================================================");

			//リソースを生成
			var program = new Program();

			//入力
			byte[] inBuf = new byte[65536];
			Stream inStr = Console.OpenStandardInput(inBuf.Length);

			Console.SetIn(new StreamReader(inStr, Console.InputEncoding, false, inBuf.Length));

			//Console.WriteLine("input DestDir");
			Console.WriteLine("保存先フォルダを入力（フルパスまたは相対パス）： ※ 入力なしで実行フォルダにダウンロード");
			string DestDir = Console.ReadLine();
			if (DestDir != "") { DestDir += "\\"; }
			//Console.WriteLine("input pre-Filename");
			Console.WriteLine("------------------------------------------------------------");
			Console.WriteLine("リンクを抜き出す要素を選択してください。\n1. \"a href=\"\n2. \"img src=\"\n3. other");
			string elem = "";
			string elem2 = "";
			int elem_s = program.GetSelect(new List<int> { 1, 2, 3 });
			if (elem_s == 1)
			{
				elem = "a href=";
			}
			else if (elem_s == 2)
			{
				elem = "img src=";
			}
			else
			{
				while (true)
				{
					elem = Console.ReadLine();
					if (elem != "") { break; }
					Console.WriteLine("入力");
				}
			}
			elem2 = elem.Split(" ")[0];

			Console.WriteLine("------------------------------------------------------------");
			Console.WriteLine("ファイル名頭に付加する文字を入力(ファイルシステム文字以外)：");
			string prefFN = Console.ReadLine();
			//Console.WriteLine("input pre-href");
			Console.WriteLine("------------------------------------------------------------");
			Console.WriteLine("リンクの先頭に付加する文字を入力：　※ /で始まる場合はサイト名、~/で始まる場合はページのディレクトリURL");
			string head = Console.ReadLine();
			//Console.WriteLine("input string");
			Console.WriteLine("------------------------------------------------------------");
			Console.WriteLine("HTMLをどのように入力しますか？\n1. ページURL\n2. 手動入力");
			string strIn = "";
			if (program.GetSelect(new List<int> { 1, 2 }) == 1)
			{
				while (true)
				{
					Console.WriteLine("リンクをhttp/httpsも含めて入力して下さい（コンマで区切り複数入力）");
					var Links = Console.ReadLine().Split(",");
					var Downloads = new List<Task<string>>();
					string errstr2 = "###ダウンロード中にエラーが発生しました###\n";
					foreach (var item in Links)
					{
						WebClient webClient = new WebClient();
						Downloads.Add(webClient.DownloadStringTaskAsync(item));
					}
					foreach (var item in Downloads)
					{
						try
						{
							item.Wait();
							Regex reg = new Regex(" +");
							strIn += reg.Replace(item.Result.Replace("\n", ""), " ");
						}
						catch (Exception e)
						{
							Console.WriteLine(errstr2 + e.ToString() + "何かキーを押して続行...");
							Console.ReadKey();
						}
					}
					if (strIn != "")
					{
						break;
					}
				}
				Console.WriteLine(strIn);
			}
			else
			{
				Console.WriteLine("HTMLを入力：");
				strIn = Console.ReadLine();
			}
			string str = strIn.Replace("amp;", "");
			Console.WriteLine("------------------------------------------------------------");
			Console.WriteLine("保存ファイル名の決定方法を選択：\n1. 手入力\n2. URLファイル名\n3. クエリから抜き出し\n4. リンク名から抜き出し\n[1~4]");

			int sfname = program.GetSelect(new List<int> { 1, 2, 3, 4 });
			//string str_sfname = "";
			//int svalid = 0;
			//while (svalid != 1) {
			//	if (svalid == 2) { Console.WriteLine("半角数字1~3のいずれかを入力してください"); }
			//	str_sfname = Console.ReadLine();
			//	if (str_sfname != "1" && str_sfname != "2" && str_sfname != "3") { svalid = 2; } else { svalid = 1; }
			//}
			//int sfname = int.Parse(str_sfname);
			string qname = "";
			if (sfname == 3)
			{
				Console.WriteLine("クエリ名を入力してください（?,,,=...の,,,の部分）");
				while (true)
				{
					qname = Console.ReadLine();
					if (qname != "")
					{
						break;
					}
					Console.WriteLine("一文字以上入力してください");
				}

			}
			Console.WriteLine("------------------------------------------------------------");
			bool ex_check = false;
			string ex = "";
			Console.WriteLine("URL拡張子を限定しますか？\n0 : 限定する\n1 : 限定しない");
			int input = program.GetSelect(new List<int> { 0, 1 });
			if (input == 0)
			{
				ex_check = true;
				Console.WriteLine("限定する\"URL拡張子\"をドット無しで入力して下さい（入力なしで拡張子なしリンクをダウンロードします）");
				ex = Console.ReadLine();
			}

			//while (true)
			//{
			//    string input = Console.ReadLine();
			//    if (input == "1")
			//    {
			//        ex_check = true;
			//        Console.WriteLine("限定する拡張子を入力して下さい（入力なしで拡張子なしリンクをダウンロードします）");
			//        ex = Console.ReadLine();
			//        break;
			//    }
			//    else if (input == "0")
			//    {
			//        break;
			//    }
			//    else
			//    {

			//    }
			//}

			Console.WriteLine("------------------------------------------------------------");
			Console.WriteLine($"保存先：{DestDir}\n検索する要素：{elem}\nファイル名付加：{prefFN}\nURL付加：{head}\n...");


			//htmlからhref部を抜き出す
			Regex reg2 = new Regex("> *<");
			Regex reg_inline = new Regex(">*</" + elem2);
			string[] str1 = reg2.Split(str);// str.Split("><");
			int cnt = 0;
			var str2 = new List<string>();//hrefリンク
			var inLines = new List<string>();
			foreach (Match item in reg_inline.Matches(str))
			{
				inLines.Add(item.Value.Split(">")[0].Split("<")[0]);
			}
			while (str1.Length - 1 >= cnt)
			{
				str2.AddRange(str1[cnt].Split('"'));
				cnt++;
			}

			//URL決定
			var urls = new List<string>();
			var link_names = new List<string>();
			string url = "";
			string urlList = "";
			string fname = "";
			cnt = 0;
			while (str2.Count - 1 >= cnt)
			{
				if (str2[cnt].Equals(elem))
				{
					url = head + str2[cnt + 1];//~のチェック未実装

					if (ex_check == true && !program.Url_ex_check(url, ex))
					{
						cnt++;
						continue;
					}

					urls.Add(url);
					link_names.Add(inLines[cnt]);

					urlList += "・" + url + "\n";
				}
				cnt++;
			}
			Console.WriteLine(urlList + $"\n以上のURL（{urls.Count()}）が見つかりました　続行するにはEnter、中止するにはCtrl+Cを押してください");
			Console.ReadLine();

			//ファイル名生成、ダウンロード

			var Fdownloads = new List<Task>();
			if (urls.Count != inLines.Count) { Console.WriteLine("wrong counts"); }
			for (int cnt2 = 0; cnt2 < urls.Count; cnt2++)
			{
				if (sfname == 1)
				{
					Console.WriteLine("ファイル名（拡張子含む）を入力してください");
					fname = Console.ReadLine();
				}
				else if (sfname == 2)
				{
					fname = Path.GetFileName(urls[cnt2]).Split("?")[0];
				}
				else if (sfname == 3)
				{
					var queries = urls[cnt2].Split("?")[1].Split("&");
					fname = HttpUtility.UrlDecode(queries.Where(i => i.Contains(qname + "=")).Single().ToString().Split("=")[1]);
				}
				else if (sfname == 4)
				{
					fname = inLines[cnt2];
				}
				//await Task.Run(() => {
				//});
				WebClient webClient2 = new WebClient();
				Fdownloads.Add(webClient2.DownloadFileTaskAsync(urls[cnt2], DestDir + prefFN + fname));

			}

			cnt = 0;
			Console.WriteLine("ダウンロードは並列に実行されます");
			string errstr = "###ダウンロード中にエラーが発生しました###\n";
			foreach (var item in Fdownloads)
			{
				cnt++;
				try
				{
					Console.WriteLine($"{cnt}/{urls.Count}完了"); //, ファイルURL : {urls[cnt]}");
					item.Wait();

				}
				catch (Exception e)
				{
					Console.WriteLine(errstr + e.ToString() + "何かキーを押して続行...");
					Console.ReadKey();
				}
			}
			inStr.Dispose();
			Console.WriteLine("ダウンロードが完了しました　何かキーを押して終了...");
			Console.ReadKey();
			return;
		}

		public bool Url_ex_check(string url, string ex)
		{
			string fname = Path.GetFileName(url).Split("?")[0];
			var fname_split = fname.Split(".");
			int fname_split_cnt = fname_split.Count();
			if (fname_split_cnt > 1 && fname_split[fname_split_cnt - 1] == ex)
			{
				return true;
			}
			else if (fname_split_cnt == 1 && ex == null)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		public int GetSelect(List<int> choices)
		{
			var strchoices = new List<string>();
			foreach (var item in choices) { strchoices.Add(item.ToString()); }
			string input = Console.ReadLine();
			while (!strchoices.Contains(input))
			{
				Console.WriteLine("選択肢を半角数字で入力して下さい");
				input = Console.ReadLine();
			}
			return int.Parse(input);
		}
	}
}
