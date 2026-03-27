<?php
    class indexLangs {
        public function __construct() {
            if(is_file('./_lib/lang/en_us.lang.php')){
                include('./_lib/lang/en_us.lang.php');
            }
        }
        public function getLang(){
            if(is_file('./_lib/lang/en_us.lang.php')){
                return $this->Nm_lang['lang_pub_index_btn_label'];
            }else{
                return false;
            }
        }
    }
    $obj = new indexLangs();
    $str_label = $obj->getLang();
    if($str_label == false){
        $str_label = "Access home application";
    }
    $str_apl = 'lanman_login';
    if(is_file("_lib/_app_data/" . $str_apl . '_ini.php'))
    {
        require("_lib/_app_data/" . $str_apl . '_ini.php');
        $str_apl = $arr_data['friendly_url'];
    }
    else
    {
        $str_apl = $str_apl . '/';
    }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LanMan Portal - Gateway</title>
    <script src="https://cdn.tailwindcss.com"></script>
	<!-- OFFLINE fallback -->
	<script src="https://unpkg.com/@tailwindcss/browser@4"></script>
	<script>
	  (function() {
		// Check if the v4 engine failed to load or initialize
		if (typeof window.tailwind === 'undefined') {
		  const link = document.createElement('link');
		  link.rel = 'stylesheet';
		  link.type = 'text/css';
		  // Use Scriptcase PHP to get the correct library path
		  link.href = "<?php echo sc_url_library('prj', 'lib', 'tailwind2.css'); ?>";
		  document.head.appendChild(link);

		  console.warn("Tailwind 4 Offline: Switched to Local Tailwind 2.");

		  // Manual 'hidden' fix for v2 compatibility
		  const style = document.createElement('style');
		  style.innerHTML = ".hidden { display: none !important; }";
		  document.head.appendChild(style);
		}
	  })();
	</script>
	
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        techCyan: { DEFAULT: '#00f2ff', dark: '#00c2cc' },
                        techPurple: { DEFAULT: '#bd00ff', dark: '#9500c9' }
                    }
                }
            }
        }
    </script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap');
        body { background-color: #030712; font-family: 'Inter', sans-serif; height: 100vh; margin: 0; }
        .bg-wrap { background-image: url('_lib/libraries/grp/lib/login/img/lanman_bg_1.png'); background-size: cover; background-position: center; }
        
        /* Heartbeat Animation */
        .heartbeat-line {
            stroke-dasharray: 1000;
            stroke-dashoffset: 1000;
            animation: dash 3s linear infinite;
        }
        @keyframes dash {
            to { stroke-dashoffset: 0; }
        }
        .glow-pulse {
            animation: pulse-glow 2s ease-in-out infinite;
        }
        @keyframes pulse-glow {
            0%, 100% { opacity: 0.3; }
            50% { opacity: 1; }
        }
    </style>
</head>
<body class="flex items-center justify-center bg-wrap relative overflow-hidden">

    <div class="absolute inset-0 bg-[#030712] bg-opacity-80 z-0"></div>
    
    <main id="gateway-card" class="relative z-20 w-full max-w-[450px] p-10 bg-slate-900/40 backdrop-blur-2xl rounded-2xl border border-techCyan/30 shadow-[0_0_30px_rgba(0,242,255,0.15)] opacity-0">
        
        <div class="text-center mb-10 animate-elem">
            <h1 class="text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-techCyan to-techPurple tracking-wider">LanMan</h1>
            <p class="text-techCyan/70 text-[10px] uppercase tracking-[0.3em] mt-2 font-bold">Central Gateway Control</p>
			<p class="text-techCyan/70 text-[8px] uppercase tracking-[0.2em] mt-2 font-bold">See: Youtube @ScriptcaseByJamie & https://github.com/JamieO77/lanman for more information!</p>
        </div>

        <div class="flex flex-col gap-4 animate-elem">
            <a href="<?php echo trim($str_apl); ?>" class="w-full block py-4 text-center font-bold rounded-lg text-white bg-gradient-to-r from-blue-600 to-techCyan-dark hover:scale-[1.01] transition-all uppercase tracking-widest text-sm shadow-[0_0_15px_rgba(0,242,255,0.2)]">
                Establish Login Uplink
            </a>

            <a href="/_lib/prod" class="w-full block py-4 text-center font-bold rounded-lg text-techCyan border border-techCyan/40 bg-slate-950/40 hover:bg-techCyan/5 transition-all uppercase tracking-widest text-sm">
                Production Environment
            </a>
        </div>

        <div class="mt-10 flex flex-col items-center animate-elem">
            <div class="flex items-center gap-3 mb-2">
                <span class="w-2 h-2 rounded-full bg-techCyan glow-pulse"></span>
                <span class="text-[10px] text-techCyan/60 uppercase tracking-widest font-bold">Host Connection Active</span>
            </div>
            
            <svg width="200" height="40" viewBox="0 0 200 40" class="opacity-50">
                <path d="M0 20 L40 20 L45 10 L50 30 L55 20 L90 20 L95 5 L105 35 L110 20 L150 20 L155 15 L160 25 L165 20 L200 20" 
                      fill="none" 
                      stroke="#00f2ff" 
                      stroke-width="2" 
                      class="heartbeat-line" />
            </svg>
            
            <p class="text-[9px] text-slate-500 mt-2 uppercase tracking-tighter">Latency: <span class="text-techCyan">12ms</span> | Status: <span class="text-techCyan">Optimal</span></p>
        </div>
    </main>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            gsap.to("#gateway-card", { opacity: 1, y: 0, duration: 1, ease: "power4.out" });
            gsap.from(".animate-elem", { opacity: 0, y: 15, stagger: 0.15, duration: 0.8, delay: 0.2 });
        });
    </script>
</body>
</html>
