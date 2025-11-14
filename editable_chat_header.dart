import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_final/presentacion/provider/chat_provider.dart';

/// Header del chat con nombre y avatar editables
class EditableChatHeader extends StatelessWidget implements PreferredSizeWidget {
  const EditableChatHeader({super.key});

  /// Muestra diálogo para editar el nombre del contacto
  void _showEditNameDialog(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();
    final TextEditingController controller = TextEditingController(
      text: chatProvider.contactName,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nombre del contacto',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          maxLength: 30,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                chatProvider.updateContactName(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Muestra diálogo para cambiar el avatar
  void _showAvatarOptions(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();
    
    final List<String> avatarOptions = [
      'https://i.pravatar.cc/150?img=1',
      'https://i.pravatar.cc/150?img=5',
      'https://i.pravatar.cc/150?img=9',
      'https://i.pravatar.cc/150?img=16',
      'https://i.pravatar.cc/150?img=20',
      'https://i.pravatar.cc/150?img=25',
      'https://i.pravatar.cc/150?img=32',
      'https://i.pravatar.cc/150?img=47',
      'https://i.pravatar.cc/150?img=48',
      'https://i.pravatar.cc/150?img=60',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar avatar'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: avatarOptions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  chatProvider.updateContactAvatar(avatarOptions[index]);
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(avatarOptions[index]),
                  backgroundColor: Colors.grey[300],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return AppBar(
          backgroundColor: Colors.teal,
          elevation: 2,
          titleSpacing: 0,
          title: Row(
            children: [
              // Avatar editable
              GestureDetector(
                onTap: () => _showAvatarOptions(context),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(chatProvider.contactAvatar),
                      backgroundColor: Colors.grey[300],
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Nombre editable
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEditNameDialog(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              chatProvider.contactName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                      const Text(
                        'en línea',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Opciones',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Editar nombre'),
                          onTap: () {
                            Navigator.pop(context);
                            _showEditNameDialog(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_camera),
                          title: const Text('Cambiar avatar'),
                          onTap: () {
                            Navigator.pop(context);
                            _showAvatarOptions(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('Información'),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('ℹ️ Cómo usar'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '💬 Para recibir respuesta:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text('Termina tu mensaje con "!" '),
                                    SizedBox(height: 12),
                                    Text(
                                      '😊 Funciones:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text('• Mantén presionado un mensaje para reaccionar'),
                                    Text('• Responde a mensajes específicos'),
                                    Text('• Edita nombre y avatar del contacto'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Entendido'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}