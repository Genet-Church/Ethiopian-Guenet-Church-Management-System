import React, { useEffect } from 'react';
import { useBlocker } from 'react-router-dom';
import { useLanguage } from '../context/LanguageContext';
import ConfirmDialog from './ConfirmDialog';

interface LeavePromptProps {
  isDirty: boolean;
}

export default function LeavePrompt({ isDirty }: LeavePromptProps) {
  const { t } = useLanguage();

  const blocker = useBlocker(
    ({ currentLocation, nextLocation }) =>
      isDirty && currentLocation.pathname !== nextLocation.pathname
  );

  // Block tab close / reload
  useEffect(() => {
    const handleBeforeUnload = (e: BeforeUnloadEvent) => {
      if (isDirty) {
        e.preventDefault();
        e.returnValue = ''; // Standard way to show browser prompt
      }
    };

    window.addEventListener('beforeunload', handleBeforeUnload);
    return () => window.removeEventListener('beforeunload', handleBeforeUnload);
  }, [isDirty]);

  return (
    <ConfirmDialog
      isOpen={blocker.state === 'blocked'}
      title={t('common.discardChangesTitle') || 'Discard Changes?'}
      message={t('common.discardChangesMessage') || 'You have unsaved changes. Are you sure you want to discard them and leave?'}
      onConfirm={() => blocker.state === 'blocked' ? blocker.proceed() : null}
      onCancel={() => blocker.state === 'blocked' ? blocker.reset() : null}
      type="warning"
      confirmText={t('common.yesDiscard') || 'Yes, Discard'}
      cancelText={t('common.cancel') || 'Cancel'}
    />
  );
}
