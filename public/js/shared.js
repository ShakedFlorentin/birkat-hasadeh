// ==================== SUPABASE CONFIG ====================
var SUPABASE_URL = 'https://xotfyrmzbcwzzpwrreva.supabase.co';
var SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhvdGZ5cm16YmN3enpwd3JyZXZhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEzNDAzMzYsImV4cCI6MjA4NjkxNjMzNn0.niazvJJk6MI1UNf8zDpw7GpfNHY_wC2c83RShFhaASI';

// Initialize Supabase client (available globally)
var supabaseClient = null;
if (window.supabase) {
  supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
}

// ==================== CATEGORIES ====================
var CATEGORIES = [
  { id: 'all', name: 'הכל', icon: '🛒' },
  { id: 'fruits', name: 'פירות', icon: '🍎' },
  { id: 'vegetables', name: 'ירקות', icon: '🥬' },
  { id: 'herbs', name: 'תבלינים וירק', icon: '🌿' },
  { id: 'exotic', name: 'אקזוטי', icon: '🥭' },
  { id: 'pantry', name: 'מזווה', icon: '🏪' },
  { id: 'juices', name: 'מיצים טבעיים', icon: '🧃' },
];

var CATEGORY_MAP = {
  fruits: 'פירות',
  vegetables: 'ירקות',
  herbs: 'תבלינים',
  exotic: 'אקזוטי',
  pantry: 'מזווה',
  juices: 'מיצים טבעיים',
};

// ==================== PRODUCT IMAGES ====================
var PRODUCT_IMAGES = {
  'תפוחים חרמון': 'https://images.unsplash.com/photo-1570913149827-d2ac84ab3f9a?w=300&h=300&fit=crop&q=80',
  'בננות': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300&h=300&fit=crop&q=80',
  'ענבים ירוקים': 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=300&h=300&fit=crop&q=80',
  'אבטיח': 'https://images.unsplash.com/photo-1589984662646-e7b2e28d0a86?w=300&h=300&fit=crop&q=80',
  'אגסים': 'https://images.unsplash.com/photo-1514756331096-242fdeb70d4a?w=300&h=300&fit=crop&q=80',
  'נקטרינות': 'https://images.unsplash.com/photo-1595124216976-89ec5c1d8fa4?w=300&h=300&fit=crop&q=80',
  'תותים': 'https://images.unsplash.com/photo-1464965911861-1fd34db45b5c?w=300&h=300&fit=crop&q=80',
  'רימונים': 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=300&h=300&fit=crop&q=80',
  'אפרסמונים': 'https://images.unsplash.com/photo-1604143929980-027618a27b67?w=300&h=300&fit=crop&q=80',
  'שזיפים': 'https://images.unsplash.com/photo-1502216980896-8cd93275ce1a?w=300&h=300&fit=crop&q=80',
  'עגבניות': 'https://images.unsplash.com/photo-1546094096-0df4bcace7b2?w=300&h=300&fit=crop&q=80',
  'מלפפונים': 'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=300&h=300&fit=crop&q=80',
  'פלפל אדום': 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=300&h=300&fit=crop&q=80',
  'פלפל ירוק': 'https://images.unsplash.com/photo-1525607551316-4a5b5e1e4fdf?w=300&h=300&fit=crop&q=80',
  'חסה': 'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=300&h=300&fit=crop&q=80',
  'גזר': 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=300&h=300&fit=crop&q=80',
  'בצל יבש': 'https://images.unsplash.com/photo-1518977676601-b32f82d65f25?w=300&h=300&fit=crop&q=80',
  'תפוח אדמה': 'https://images.unsplash.com/photo-1508313880080-c4bef0730395?w=300&h=300&fit=crop&q=80',
  'חציל': 'https://images.unsplash.com/photo-1613743983303-b3e89f8a3b72?w=300&h=300&fit=crop&q=80',
  'קישוא': 'https://images.unsplash.com/photo-1563252722-bce4a91f4a09?w=300&h=300&fit=crop&q=80',
  'כרובית': 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=300&h=300&fit=crop&q=80',
  'ברוקולי': 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=300&h=300&fit=crop&q=80',
  'בטטה': 'https://images.unsplash.com/photo-1596097635121-14b63a7a0359?w=300&h=300&fit=crop&q=80',
  'כרוב לבן': 'https://images.unsplash.com/photo-1594282486552-05b4d80fbb9f?w=300&h=300&fit=crop&q=80',
  'סלרי': 'https://images.unsplash.com/photo-1580391564590-aeca65c5e2d3?w=300&h=300&fit=crop&q=80',
  'פטרוזיליה': 'https://images.unsplash.com/photo-1599689019338-50deb475f380?w=300&h=300&fit=crop&q=80',
  'כוסברה': 'https://images.unsplash.com/photo-1526318472351-c75fcf070305?w=300&h=300&fit=crop&q=80',
  'נענע': 'https://images.unsplash.com/photo-1628557044797-f21a177c37ec?w=300&h=300&fit=crop&q=80',
  'שמיר': 'https://images.unsplash.com/photo-1599689019338-50deb475f380?w=300&h=300&fit=crop&q=80',
  'בצל ירוק': 'https://images.unsplash.com/photo-1590165482129-1b8b27698780?w=300&h=300&fit=crop&q=80',
  'שום': 'https://images.unsplash.com/photo-1540148426945-6cf22a6b2571?w=300&h=300&fit=crop&q=80',
  'תפוזים': 'https://images.unsplash.com/photo-1547514701-42fee727e36e?w=300&h=300&fit=crop&q=80',
  'לימון': 'https://images.unsplash.com/photo-1590502593747-42a996133562?w=300&h=300&fit=crop&q=80',
  'קלמנטינות': 'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?w=300&h=300&fit=crop&q=80',
  'פומלה': 'https://images.unsplash.com/photo-1577234286642-fc512a5f8f11?w=300&h=300&fit=crop&q=80',
  'אשכולית': 'https://images.unsplash.com/photo-1577234286642-fc512a5f8f11?w=300&h=300&fit=crop&q=80',
  'מנגו': 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=300&h=300&fit=crop&q=80',
  'אבוקדו': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300&h=300&fit=crop&q=80',
  'אננס': 'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=300&h=300&fit=crop&q=80',
  'קיווי': 'https://images.unsplash.com/photo-1585059895524-72359e06133a?w=300&h=300&fit=crop&q=80',
  'פסיפלורה': 'https://images.unsplash.com/photo-1604495772376-9657f0035eb5?w=300&h=300&fit=crop&q=80',
  'ליצי': 'https://images.unsplash.com/photo-1577234286642-fc512a5f8f11?w=300&h=300&fit=crop&q=80',
};

// Helper to get product image - checks DB image_url first, then local map
function getProductImage(name, imageUrl) {
  return imageUrl || PRODUCT_IMAGES[name] || null;
}
